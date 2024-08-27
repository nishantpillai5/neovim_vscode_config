local M = {}

M.keys = {
  { '<leader>gw', desc = 'worktree_switch' },
  { '<leader>gW', desc = 'worktree_create' },
}

M.keymaps = function()
  vim.keymap.set('n', '<leader>gw', function()
    require('telescope').extensions.git_worktree.git_worktree()
  end, { desc = 'worktree_switch' })

  vim.keymap.set('n', '<leader>gW', function()
    require('telescope').extensions.git_worktree.create_git_worktree()
  end, { desc = 'worktree_create' })
end

M.setup = function()
  require('telescope').load_extension 'git_worktree'
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
