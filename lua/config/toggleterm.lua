local M = {}

M.keys = {
  { '<leader>Oo', desc = 'toggle' },
}

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

local panel_align = function()
  return require('common.env').PANEL_POSITION
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>Oo', init_or_toggle)
end

M.setup = function()
  require('toggleterm').setup {
    direction = panel_align(),
    size = function(term)
      if term.direction == 'horizontal' then
        return vim.o.lines * 0.30
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.30
      end
    end,
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
