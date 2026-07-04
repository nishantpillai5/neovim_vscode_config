local M = {}

M.keys = {
  { '<leader>aa', desc = 'chat', mode = { 'n', 'v' } },
  { '<leader>av', desc = 'attach_visual', mode = 'v' },
  { '<leader>aV', desc = 'attach_buffer' },
  {
    '<leader>av',
    '<cmd>ClaudeCodeTreeAdd<cr>',
    desc = 'attach_file',
    ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
  },
  { '<leader>as', desc = 'session_continue' },
  { '<leader>af', desc = 'find_session' },
  { '<leader>aF', desc = 'find_session_cmd' },
  { '<leader>aj', desc = 'diff_accept' },
  { '<leader>ak', desc = 'diff_reject' },
  { '<leader>am', desc = 'model' },
}

local function relative_time(mtime)
  local diff = os.time() - mtime
  if diff < 60 then
    return 'just now'
  elseif diff < 3600 then
    return math.floor(diff / 60) .. 'm ago'
  elseif diff < 86400 then
    return math.floor(diff / 3600) .. 'h ago'
  elseif diff < 604800 then
    return math.floor(diff / 86400) .. 'd ago'
  elseif diff < 2592000 then
    return math.floor(diff / 604800) .. 'w ago'
  elseif diff < 31536000 then
    return math.floor(diff / 2592000) .. 'mo ago'
  else
    return math.floor(diff / 31536000) .. 'y ago'
  end
end

local function extract_text(raw)
  if raw:find('<local%-command%-caveat>', 1, true) then
    return nil
  end
  local cmd_name = raw:match '<command%-name>%s*(.-)%s*</command%-name>'
  if cmd_name and cmd_name ~= '' then
    return cmd_name
  end
  local stripped = raw:gsub('<[^>]+>', ' '):gsub('%s+', ' '):match '^%s*(.-)%s*$'
  return stripped ~= '' and stripped or nil
end

local function build_path_map()
  local path_map = {}
  local cj = io.open(vim.fn.expand '~/.claude.json', 'r')
  if cj then
    local ok, data = pcall(vim.json.decode, cj:read '*a')
    cj:close()
    if ok and data.projects then
      local home = vim.fn.expand '~'
      for actual_path, _ in pairs(data.projects) do
        local display = actual_path:gsub('^' .. vim.pesc(home), '~')
        path_map[actual_path:gsub('[/.]', '-')] = display
      end
    end
  end
  return path_map
end

local function read_session_title(session_file)
  local sf = io.open(session_file, 'r')
  if not sf then
    return ''
  end
  local ai_title, first_msg = nil, ''
  for line in sf:lines() do
    local ok, entry = pcall(vim.json.decode, line)
    if ok then
      if entry.type == 'ai-title' and entry.aiTitle then
        ai_title = entry.aiTitle
      elseif first_msg == '' and entry.type == 'user' then
        local content = entry.message and entry.message.content
        local raw
        if type(content) == 'string' then
          raw = content
        elseif type(content) == 'table' then
          for _, part in ipairs(content) do
            if type(part) == 'table' and part.type == 'text' and part.text then
              raw = part.text
              break
            end
          end
        end
        if raw then
          first_msg = extract_text(raw:sub(1, 200)) or ''
        end
      end
    end
  end
  sf:close()
  return (ai_title or first_msg):gsub('\n', ' '):sub(1, 80)
end

local function pick_claude_session()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local path_map = build_path_map()
  local sessions_base = vim.fn.expand '~/.claude/projects'
  local cwd_encoded = vim.fn.getcwd():gsub('[/.]', '-')
  local entries = {}

  for _, project_dir in ipairs(vim.fn.glob(sessions_base .. '/*', false, true)) do
    local encoded_name = vim.fn.fnamemodify(project_dir, ':t')
    local display_project = path_map[encoded_name] or encoded_name

    for _, session_file in ipairs(vim.fn.glob(project_dir .. '/*.jsonl', false, true)) do
      table.insert(entries, {
        session_id = vim.fn.fnamemodify(session_file, ':t:r'),
        project = display_project,
        summary = read_session_title(session_file),
        mtime = vim.fn.getftime(session_file),
        loadable = encoded_name == cwd_encoded,
      })
    end
  end

  table.sort(entries, function(a, b)
    if a.loadable ~= b.loadable then
      return a.loadable
    end
    return a.mtime > b.mtime
  end)

  pickers
    .new({}, {
      prompt_title = 'Claude Sessions',
      finder = finders.new_table {
        results = entries,
        entry_maker = function(entry)
          local make_display = function(e)
            local title = e.summary ~= '' and e.summary or '(no message)'
            local path_str = '  ' .. e.project
            local time_str = '  ' .. relative_time(e.mtime)
            local display = title .. path_str .. time_str
            if not e.loadable then
              return display, { { { 0, #display }, 'LspInlayHint' } }
            end
            return display,
              {
                { { #title, #title + #path_str }, 'Comment' },
                { { #title + #path_str, #display }, 'Special' },
              }
          end
          return {
            value = entry.session_id,
            display = make_display,
            ordinal = entry.summary .. ' ' .. entry.project,
            summary = entry.summary,
            project = entry.project,
            mtime = entry.mtime,
            loadable = entry.loadable,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        local function resume_session()
          local selection = action_state.get_selected_entry()
          if selection and not selection.loadable then
            vim.notify(
              'Session belongs to ' .. selection.project .. ' — not resumable from this directory.',
              vim.log.levels.WARN
            )
            return
          end
          actions.close(prompt_bufnr)
          if selection then
            vim.cmd('ClaudeCode --resume ' .. selection.value)
          end
        end
        map('i', '<CR>', resume_session)
        map('n', '<CR>', resume_session)
        return true
      end,
    })
    :find()
end

-- Claude Code usage in the statusline.
-- Reads ~/.cache/claude/usage.json, written by scripts/claude_statusline.sh
-- (hooked into Claude Code via the statusLine setting). No polling: Claude
-- Code pushes fresh data on every statusline update; the reset countdown is
-- computed locally from the cached resets_at timestamp.
local USAGE_CACHE = vim.fn.expand '~/.cache/claude/usage.json'
local USAGE_TTL = 15 -- seconds between cache file re-reads
local usage_state = { checked_at = 0, mtime = 0, data = nil }

local function read_usage_cache()
  local now = os.time()
  if now - usage_state.checked_at < USAGE_TTL then
    return usage_state.data
  end
  usage_state.checked_at = now

  local stat = vim.uv.fs_stat(USAGE_CACHE)
  if not stat then
    usage_state.data = nil
    return nil
  end
  if stat.mtime.sec == usage_state.mtime then
    return usage_state.data
  end
  usage_state.mtime = stat.mtime.sec

  local fd = io.open(USAGE_CACHE, 'r')
  if not fd then
    return usage_state.data
  end
  local ok, decoded = pcall(vim.json.decode, fd:read '*a')
  fd:close()
  usage_state.data = ok and decoded or nil
  return usage_state.data
end

local function fmt_remaining(resets_at)
  local secs = resets_at - os.time()
  if secs <= 0 then
    return nil
  end
  local d = math.floor(secs / 86400)
  local h = math.floor(secs % 86400 / 3600)
  local m = math.floor(secs % 3600 / 60)
  if d > 0 then
    return ('%dd%dh'):format(d, h)
  elseif h > 0 then
    return ('%dh%02dm'):format(h, m)
  else
    return ('%dm'):format(m)
  end
end

local function fmt_usage_window(win, label)
  if not win or not win.used_percentage then
    return nil
  end
  local left = win.resets_at and fmt_remaining(win.resets_at)
  -- window already reset since last cache write -> usage is back to ~0
  local pct = left and win.used_percentage or 0
  -- '%%%%' -> literal '%%' in the string, which the statusline renders as '%'
  local part = ('%s %.0f%%%%'):format(label, pct)
  if left then
    part = part .. (' 󰔛 %s'):format(left)
  end
  return part
end

local function lualine_usage()
  local data = read_usage_cache()
  if not data then
    return ''
  end
  local parts = {}
  for _, win in ipairs { { data.five_hour, '5h' }, { data.seven_day, '7d' } } do
    local part = fmt_usage_window(win[1], win[2])
    if part then
      table.insert(parts, part)
    end
  end
  if #parts == 0 then
    return ''
  end
  return '󰚩 ' .. table.concat(parts, ' ')
end

M.lualine = function()
  local lualineX = require('lualine').get_config().sections.lualine_x or {}
  table.insert(lualineX, 1, { lualine_usage })

  require('lualine').setup { sections = { lualine_x = lualineX } }
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap({ 'n', 'v' }, '<leader>aa', function()
    vim.cmd 'ClaudeCodeFocus'
  end)
  set_keymap('v', '<leader>av', function()
    vim.cmd 'ClaudeCodeSend'
  end)
  set_keymap('n', '<leader>aV', function()
    vim.cmd 'ClaudeCodeAdd %'
  end)
  set_keymap('n', '<leader>as', function()
    vim.cmd 'ClaudeCode --continue'
  end)
  set_keymap('n', '<leader>af', pick_claude_session)
  set_keymap('n', '<leader>aF', function()
    vim.cmd 'ClaudeCode --resume'
  end)
  set_keymap('n', '<leader>aj', function()
    vim.cmd 'ClaudeCodeDiffAccept'
  end)
  set_keymap('n', '<leader>ak', function()
    vim.cmd 'ClaudeCodeDiffDeny'
  end)
  set_keymap('n', '<leader>am', function()
    vim.cmd 'ClaudeCodeSelectModel'
  end)
end

M.setup = function()
  require('claudecode').setup()
end

M.config = function()
  M.setup()
  M.keymaps()
  M.lualine()
end

-- M.config()

return M
