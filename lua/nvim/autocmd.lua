-- Stop insert mode when terminal is closed
vim.api.nvim_create_autocmd('TermClose', {
  pattern = '*',
  callback = function()
    vim.cmd 'stopinsert'
  end,
})

-- Auto enter insert mode when entering a terminal buffer
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    -- Wait briefly just in case we immediately switch out of the buffer
    vim.defer_fn(function()
      if vim.bo.buftype == 'terminal' then
        vim.cmd [[stopinsert]]
        local line_count = vim.api.nvim_buf_line_count(0)
        if line_count > 0 then
          vim.api.nvim_win_set_cursor(0, { line_count, 0 })
        end
      end
    end, 100)
  end,
})

-- Set filetype javascript for strudel
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.str',
  callback = function()
    vim.bo.filetype = 'javascript'
  end,
})

-- Grey out llama.vim FIM hint ghost text
local function set_llama_hl()
  vim.api.nvim_set_hl(0, 'llama_hl_fim_hint', { fg = '#808080', italic = true })
end
set_llama_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_llama_hl })

-- Time diff virtual text for adjacent HH:MM lines in notes
local time_diff_ns = vim.api.nvim_create_namespace 'time_diff'

local function update_time_diffs(buf)
  vim.api.nvim_buf_clear_namespace(buf, time_diff_ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, line in ipairs(lines) do
    local h1, m1, h2, m2 = line:match '(%d+):(%d+)-(%d+):(%d+)'
    if h1 then
      local diff = math.abs((tonumber(h1) * 60 + tonumber(m1)) - (tonumber(h2) * 60 + tonumber(m2)))
      vim.api.nvim_buf_set_extmark(buf, time_diff_ns, i - 1, 0, {
        virt_text = { { string.format('%dh %dm', math.floor(diff / 60), diff % 60), 'Comment' } },
        virt_text_pos = 'eol',
      })
    end
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'TextChangedI' }, {
  group = vim.api.nvim_create_augroup('TimeDiff', { clear = true }),
  pattern = '*.md',
  callback = function(ev)
    local notes_dir = require('common.env').DIR_NOTES
    local current_file = vim.fn.expand('%:p'):gsub('\\', '/'):lower()
    if current_file:find(notes_dir:gsub('\\', '/'):lower(), 1, true) then
      update_time_diffs(ev.buf)
    end
  end,
})

-- Purple tint background for toggleterm buffers (re-applied on ColorScheme to survive theme reloads)
-- local function set_term_hl()
--   vim.api.nvim_set_hl(0, 'TermNormal', { bg = '#1e1030' })
-- end
-- set_term_hl()
-- vim.api.nvim_create_autocmd('ColorScheme', { callback = set_term_hl })
-- vim.api.nvim_create_autocmd({ 'TermOpen', 'BufWinEnter' }, {
--   callback = function(ev)
--     local buftype = vim.bo[ev.buf].buftype
--     local bufname = vim.api.nvim_buf_get_name(ev.buf)
--     local win = vim.fn.bufwinid(ev.buf)
--     local curwin = vim.api.nvim_get_current_win()
--     local curbuf = vim.api.nvim_get_current_buf()
--     local all_wins = vim.api.nvim_list_wins()
--     vim.notify(string.format(
--       '[tint] event=%s buf=%d buftype=%s bufwinid=%d curwin=%d curbuf=%d nwins=%d name=%s',
--       ev.event, ev.buf, buftype, win, curwin, curbuf, #all_wins, bufname
--     ), vim.log.levels.INFO)
--     if buftype ~= 'terminal' then return end
--     if not bufname:find 'toggleterm' then return end
--     if win ~= -1 then
--       vim.api.nvim_set_option_value('winhighlight', 'Normal:TermNormal', { win = win })
--       vim.notify('[tint] applied to win=' .. win .. ' (curwin=' .. curwin .. ')', vim.log.levels.INFO)
--     else
--       vim.notify('[tint] bufwinid=-1, scheduling retry', vim.log.levels.WARN)
--       vim.schedule(function()
--         local win2 = vim.fn.bufwinid(ev.buf)
--         vim.notify('[tint] retry: bufwinid=' .. win2, vim.log.levels.WARN)
--         if win2 ~= -1 then
--           vim.api.nvim_set_option_value('winhighlight', 'Normal:TermNormal', { win = win2 })
--         end
--       end)
--     end
--   end,
-- })