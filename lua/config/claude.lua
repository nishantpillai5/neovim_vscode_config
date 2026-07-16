local M = {}

M.keys = {
  { '<leader>aa', desc = 'toggle', mode = { 'n', 'v' } },
  { '<leader>al', desc = 'interrupt', mode = { 'n', 'v' } },
  { '<leader>ax', desc = 'kill', mode = { 'n', 'v' } },
  { '<leader><leader>', desc = 'prompt', mode = { 'n', 'v' } },
  { '<leader>j', desc = 'accept_prompt', mode = { 'n', 'v' } },
  { '<leader>k', desc = 'reject_prompt', mode = { 'n', 'v' } },
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
  { '<leader>ay', desc = 'diff_accept' },
  { '<leader>an', desc = 'diff_reject' },
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

-- Forward declaration: defined lower in the file, used by the session picker.
local show_no_focus

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
            show_no_focus('--resume ' .. selection.value)
          end
        end
        map('i', '<CR>', resume_session)
        map('n', '<CR>', resume_session)
        return true
      end,
    })
    :find()
end

-- Write raw bytes straight to the running Claude terminal's PTY without moving
-- focus, so its prompts can be answered from whatever buffer you're in. Returns
-- false (and notifies) when no live Claude terminal/channel is available.
local function send_raw(keys)
  local term = require 'claudecode.terminal'
  local bufnr = term.get_active_terminal_bufnr()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    vim.notify('No Claude terminal running', vim.log.levels.WARN)
    return false
  end
  local chan = vim.b[bufnr] and vim.b[bufnr].terminal_job_id
  if not chan or chan == 0 then
    chan = vim.bo[bufnr].channel
  end
  if not chan or chan == 0 then
    vim.notify('No Claude terminal channel', vim.log.levels.WARN)
    return false
  end
  local ok, written = pcall(vim.fn.chansend, chan, keys)
  if not ok or written == 0 then
    vim.notify('Claude terminal channel is closed', vim.log.levels.WARN)
    return false
  end
  return true
end

local function open_prompt_input()
  local width = math.min(100, math.max(40, math.floor(vim.o.columns * 0.7)))
  local max_height = math.max(1, math.floor(vim.o.lines * 0.5))
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = 'wipe'
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = 1,
    row = math.floor((vim.o.lines - 1) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' Claude ',
    title_pos = 'center',
  })
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true

  local function fit_height()
    if not vim.api.nvim_win_is_valid(win) then
      return
    end
    local rows = 0
    for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
      rows = rows + math.max(1, math.ceil(vim.fn.strdisplaywidth(line) / width))
    end
    rows = math.max(1, math.min(rows, max_height))
    vim.api.nvim_win_set_config(win, {
      relative = 'editor',
      width = width,
      height = rows,
      row = math.floor((vim.o.lines - rows) / 2),
      col = math.floor((vim.o.columns - width) / 2),
    })
  end
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    buffer = buf,
    callback = fit_height,
  })

  local closed = false
  local function finish(send)
    if closed then
      return
    end
    closed = true
    local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    -- Closing the float from insert mode leaves the global insert state on, so
    -- focus returns to your buffer still in insert -- force normal mode back.
    vim.schedule(function()
      vim.cmd 'stopinsert'
    end)
    if send and text:gsub('%s', '') ~= '' then
      -- Send the text WITHOUT a submit, then press Enter separately a beat
      -- later: a combined text+CR races Claude's TUI and the submit gets
      -- dropped, whereas a standalone CR (same as <leader>aj) reliably submits.
      require('claudecode.terminal').send_to_terminal(text, { submit = false, focus = false })
      vim.defer_fn(function()
        send_raw '\r'
      end, 100)
    end
  end
  vim.keymap.set({ 'i', 'n' }, '<CR>', function()
    finish(true)
  end, { buffer = buf })
  vim.keymap.set({ 'i', 'n' }, '<Esc>', function()
    finish(false)
  end, { buffer = buf })
  vim.keymap.set('n', 'q', function()
    finish(false)
  end, { buffer = buf })
  vim.cmd 'startinsert'
end

-- Forward declaration: assigned lower in the file, called from show_no_focus.
local ensure_terminal_autoscroll

local function claude_win()
  local bufnr = require('claudecode.terminal').get_active_terminal_bufnr()
  if not bufnr then
    return nil
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
  return nil
end

function show_no_focus(cmd_args)
  local origin = vim.api.nvim_get_current_win()
  require('claudecode.terminal').ensure_visible({}, cmd_args)
  ensure_terminal_autoscroll()
  vim.schedule(function()
    if vim.api.nvim_win_is_valid(origin) and vim.api.nvim_get_current_win() ~= origin then
      vim.api.nvim_set_current_win(origin)
    end
  end)
end

local function toggle_no_focus(cmd_args)
  if claude_win() then
    require('claudecode.terminal').simple_toggle()
  else
    show_no_focus(cmd_args)
  end
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap({ 'n', 'v' }, '<leader>aa', function()
    toggle_no_focus()
  end)

  set_keymap({ 'n', 'v' }, '<leader><leader>', open_prompt_input)

  -- Answer Claude's prompt without leaving your file: <CR> accepts the
  -- highlighted option, <Esc> rejects/cancels it.
  set_keymap({ 'n', 'v' }, '<leader>j', function()
    send_raw '\r'
  end)
  set_keymap({ 'n', 'v' }, '<leader>k', function()
    send_raw '\27'
  end)
  -- Interrupt Claude's current turn (Esc) without leaving your file.
  set_keymap({ 'n', 'v' }, '<leader>al', function()
    send_raw '\27'
  end)

  set_keymap({ 'n', 'v' }, '<leader>ax', function()
    local bufnr = require('claudecode.terminal').get_active_terminal_bufnr()
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end)

  set_keymap('v', '<leader>av', function()
    vim.cmd 'ClaudeCodeSend'
  end)

  set_keymap('n', '<leader>aV', function()
    vim.cmd 'ClaudeCodeAdd %'
  end)

  set_keymap('n', '<leader>as', function()
    show_no_focus '--continue'
  end)

  set_keymap('n', '<leader>af', pick_claude_session)

  set_keymap('n', '<leader>aF', function()
    vim.cmd 'ClaudeCode --resume'
  end)

  set_keymap('n', '<leader>ay', function()
    vim.cmd 'ClaudeCodeDiffAccept'
  end)

  set_keymap('n', '<leader>an', function()
    vim.cmd 'ClaudeCodeDiffDeny'
  end)

  set_keymap('n', '<leader>am', function()
    vim.cmd 'ClaudeCodeSelectModel'
  end)
end

M.setup = function()
  require('claudecode').setup {
    terminal = {
      split_width_percentage = 0.42,
    },
  }
end

-- Detect the Claude Code terminal by the command in its term:// buffer name
-- ("term://{cwd}//{pid}:{command}") -- test the command part only so a plain
-- shell opened inside a .claude/ dir isn't matched.
local function is_claude_terminal(buf)
  if vim.bo[buf].buftype ~= 'terminal' then
    return false
  end
  local name = vim.api.nvim_buf_get_name(buf)
  local cmd = name:match ':([^:]*)$' or name
  return cmd:find('claude', 1, true) ~= nil
end

-- Neovim only auto-follows terminal output in the *focused* window, and terminal
-- buffers don't fire nvim_buf_attach on_lines for PTY output -- so while you edit
-- elsewhere the Claude terminal streams past the bottom of its viewport. Poll on
-- a timer and keep any UNFOCUSED window showing a Claude terminal pinned to its
-- last line. The focused window is left alone (Neovim follows it natively, and
-- you may be scrolling its history there).
local autoscroll_timer = nil
function ensure_terminal_autoscroll()
  if autoscroll_timer then
    return
  end
  autoscroll_timer = vim.uv.new_timer()
  autoscroll_timer:start(
    250,
    250,
    vim.schedule_wrap(function()
      local cur = vim.api.nvim_get_current_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win ~= cur and vim.api.nvim_win_is_valid(win) then
          local buf = vim.api.nvim_win_get_buf(win)
          if is_claude_terminal(buf) then
            local last = vim.api.nvim_buf_line_count(buf)
            pcall(vim.api.nvim_win_set_cursor, win, { last, 0 })
          end
        end
      end
    end)
  )
end

-- Claude terminal behavior: drop into insert ready to type, enable jk-to-escape
-- and tmux-style split navigation from terminal-insert (buffer-local), and keep
-- unfocused windows scrolled to the newest output.
-- True when the only non-floating windows left (across all tabpages) show the
-- Claude terminal -- i.e. every editing window is gone and Claude is all that
-- remains. Floating windows (prompt box, popups) are ignored.
local function only_claude_windows_left()
  local claude, other = 0, 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == '' then
      if is_claude_terminal(vim.api.nvim_win_get_buf(win)) then
        claude = claude + 1
      else
        other = other + 1
      end
    end
  end
  return claude > 0 and other == 0
end

local function has_unsaved_changes()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == '' and vim.bo[buf].modified then
      return true
    end
  end
  return false
end

M.autocmds = function()
  local group = vim.api.nvim_create_augroup('ClaudeTerminal', { clear = true })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    pattern = 'term://*',
    callback = function()
      -- Wait briefly just in case we immediately switch out of the buffer
      vim.defer_fn(function()
        if not is_claude_terminal(0) then
          return
        end
        ensure_terminal_autoscroll()
        -- jk leaves terminal-insert (buffer-local, so other terminals keep jk literal)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], { buffer = 0, silent = true, desc = 'escape terminal mode' })
        -- tmux-style split navigation from terminal-insert, scoped to this
        -- buffer so shells keep <C-h/j/k/l> for their own line editing.
        for key, dir in pairs { h = 'Left', j = 'Down', k = 'Up', l = 'Right' } do
          vim.keymap.set(
            't',
            '<C-' .. key .. '>',
            [[<C-\><C-n><Cmd>NvimTmuxNavigate]] .. dir .. [[<CR>]],
            { buffer = 0, silent = true, desc = 'navigate ' .. dir:lower() }
          )
        end
        vim.cmd 'startinsert'
      end, 100)
    end,
  })

  -- When the last editing window is closed and only the Claude terminal remains,
  -- quit Neovim. Deferred to a clean tick (out of the WinClosed cascade) and
  -- guarded so it fires once; bail if any file buffer is modified so unsaved work
  -- is never lost.
  local quitting = false
  vim.api.nvim_create_autocmd('WinClosed', {
    group = group,
    callback = function()
      if quitting then
        return
      end
      vim.defer_fn(function()
        if quitting or not only_claude_windows_left() or has_unsaved_changes() then
          return
        end
        quitting = true
        vim.cmd 'noautocmd qall!'
      end, 50)
    end,
  })
end

M.config = function()
  M.setup()
  M.keymaps()
  M.autocmds()
end

-- M.config()

return M
