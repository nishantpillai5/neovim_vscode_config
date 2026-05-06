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
  { '<leader>ac', desc = 'continue' },
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
      })
    end
  end

  local cwd = vim.fn.getcwd()
  table.sort(entries, function(a, b)
    local a_cur = a.project == cwd
    local b_cur = b.project == cwd
    if a_cur ~= b_cur then
      return a_cur
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
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        local function resume_session()
          local selection = action_state.get_selected_entry()
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
  set_keymap('n', '<leader>ac', function()
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
end

-- M.config()

return M
