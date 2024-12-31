local M = {}

M.keys = {
  { '<leader>fgh', desc = 'hunks' },
  { '<leader>ghf', desc = 'find' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  local function git_hunk_finder()
    require('telescope').extensions.git_hunk()
    -- vim.cmd 'Telescope git_hunk'
  end

  set_keymap('n', '<leader>fgh', git_hunk_finder)
  set_keymap('n', '<leader>ghf', git_hunk_finder)
end

M.config = function()
  local status, _ = pcall(require, 'git_hunk')
  if status then
    require('telescope').load_extension 'git_hunk'
  else
    vim.notify 'git_hunk extension not found'
  end

  M.keymaps()
end

-- M.config()

return M
