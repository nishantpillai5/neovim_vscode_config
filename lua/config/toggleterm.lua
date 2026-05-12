local M = {}

M.keys = {
  { '<leader>o;', desc = 'toggle' },
}

local toggle_terminal = function()
  vim.cmd [[ exe 1 . "ToggleTerm" ]]
end

local panel_align = function()
  return require('common.env').PANEL_POSITION
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>o;', toggle_terminal)
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
    close_on_exit = false,
    start_in_insert = false,
    hide_numbers = true,
    persist_size = false,
    auto_scroll = false,
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
