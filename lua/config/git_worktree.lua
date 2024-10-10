_G.worktree_create_callback = _G.worktree_create_callback or nil

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

  local Hooks = require 'git-worktree.hooks'

  Hooks.register(Hooks.type.CREATE, function(path, prev_path)
    if _G.worktree_create_callback ~= nil then
      _G.worktree_create_callback(path, prev_path)
    else
      vim.notify('No git worktree callback', vim.log.levels.WARN)
    end
  end)

  Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
    vim.notify('Moved:' .. prev_path .. '  ~>  ' .. path)

    -- if vim.fn.expand('%'):find '^oil:///' then
    --   require('oil').open(vim.fn.getcwd())
    -- else
    --   Hooks.builtins.update_current_buffer_on_switch(path, prev_path)
    -- end
  end)
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
