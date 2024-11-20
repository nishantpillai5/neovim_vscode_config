local M = {}

M.keys = {
  { '<leader>ed', desc = 'diff_file_current' },
  { '<leader>eD', desc = 'diff_file_select_both' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>ed', function()
    require('telescope').extensions.diff.diff_current { hidden = true, no_ignore = true }
  end)

  set_keymap('n', '<leader>eD', function()
    require('telescope').extensions.diff.diff_files { hidden = true, no_ignore = true }
  end)
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
