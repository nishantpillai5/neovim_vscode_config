local M = {}

M.keys = {
  { '<leader>wW', desc = 'select_project' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>wW', function()
    require('telescope').extensions.project.project()
  end, { desc = 'select_project' })
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
