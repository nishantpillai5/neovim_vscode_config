local M = {}

M.keys = {
  { '<leader>fgh', desc = 'hunks' },
  { '<leader>ghf', desc = 'find' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  -- set_keymap('n', '<leader>fgh', function()
  --   vim.cmd 'Telescope git_hunk'
  -- end)

  set_keymap('n', '<leader>fgh', function()
    require('telescope').extensions.git_hunk.git_hunk()
  end)

  -- set_keymap('n', '<leader>ghf', function()
  --   vim.cmd 'Telescope git_hunk'
  -- end)
end

M.config = function()
  require('telescope').load_extension 'git_hunk'
  M.keymaps()
end

-- M.config()

return M
