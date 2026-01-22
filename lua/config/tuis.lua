local M = {}

M.keys = { { '<leader>fz', desc = 'choose_tui' } }

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>fz', function()
    require('tuis').choose()
  end)
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
