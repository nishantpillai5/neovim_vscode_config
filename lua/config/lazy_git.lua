local M = {}

M.keys_all = {
  { "<leader>g'", '<cmd>LazyGit<cr>', desc = 'lazygit', vsc_cmd = 'lazygit-vscode.toggle' },
}
M.keys = require('common.utils').filter_keymap(M.keys_all)

M.cmd = {
  'LazyGit',
  'LazyGitConfig',
  'LazyGitCurrentFile',
  'LazyGitFilter',
  'LazyGitFilterCurrentFile',
}

M.setup = function() end

M.config = function() end

-- M.config()

return M
