local M = {}

M.keys = {
  { '<leader>es', '<cmd>Vista focus<cr>', mode = 'n', desc = 'symbols' },
  { '<leader>eS', '<cmd>Vista!!<cr>', mode = 'n', desc = 'symbols_close' },
}

M.setup = function()
  local align = require('common.env').SIDEBAR_POSITION
  if align == 'left' then
    vim.g.vista_sidebar_position = 'vertical topleft'
  else
    vim.g.vista_sidebar_position = 'vertical botright'
  end
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
