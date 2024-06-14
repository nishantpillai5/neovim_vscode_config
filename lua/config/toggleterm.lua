local M = {}

local init_or_toggle = function()
  local buffers = vim.api.nvim_list_bufs()
  local toggleterm_exists = false
  for _, buf in ipairs(buffers) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:find 'toggleterm' then
      toggleterm_exists = true
      break
    end
  end

  if not toggleterm_exists then
    vim.cmd [[ exe 1 . "ToggleTerm" ]]
  else
    require('toggleterm').toggle_all(true)
  end
end

M.keymaps = function()
  vim.keymap.set('n', '<leader>;;', init_or_toggle, { desc = 'Terminal.toggle', silent = true })
end

M.setup = function()
  require('toggleterm').setup {
    size = vim.o.columns * 0.35,
    direction = 'vertical',
    close_on_exit = true,
    start_in_insert = false,
    hide_numbers = true,
    persist_size = false,
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
