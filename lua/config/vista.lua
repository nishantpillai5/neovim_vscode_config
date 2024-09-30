local M = {}

M.keys = {
  { '<leader>es', '<cmd>Vista focus<cr>', mode = 'n', desc = 'symbols' },
  { '<leader>eS', '<cmd>Vista!!<cr>', mode = 'n', desc = 'symbols_close' },
}

M.setup = function()
  vim.g.vista_echo_cursor = 0
  vim.g.vista_echo_cursor_strategy = 'floating_win'
  vim.g.vista_cursor_delay = 1500
  vim.g.vista_sidebar_width = 40
end

M.config = function()
  M.setup()
end

-- M.config()

return M
