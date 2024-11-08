local M = {}

M.keys = {
  { '[x', desc = 'conflict' },
  { ']x', desc = 'conflict' },
  { '<leader>gxo', desc = 'ours' },
  { '<leader>gxt', desc = 'theirs' },
  { '<leader>gxb', desc = 'both' },
  { '<leader>gxn', desc = 'none' },
}

M.cmd = { 'GitConflictPrevConflict', 'GitConflictNextConflict' }

M.keymaps = function()
  -- vim.keymap.set('n', '[x', '<cmd>GitConflictPrevConflict<cr>', { desc = 'conflict' })
  -- vim.keymap.set('n', ']x', '<cmd>GitConflictNextConflict<cr>', { desc = 'conflict' })

  -- vim.keymap.set('n', '[x', '<Plug>(git-conflict-prev-conflict)', { desc = 'conflict' })
  -- vim.keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)', { desc = 'conflict' })

  vim.keymap.set('n', '<leader>gxo', '<Plug>(git-conflict-ours)', { desc = 'ours' })
  vim.keymap.set('n', '<leader>gxt', '<Plug>(git-conflict-theirs)', { desc = 'theirs' })
  vim.keymap.set('n', '<leader>gxb', '<Plug>(git-conflict-both)', { desc = 'both' })
  vim.keymap.set('n', '<leader>gxn', '<Plug>(git-conflict-none)', { desc = 'none' })

  -- TODO: fix keymaps above are not working
  vim.keymap.set('n', '[x', '?<<<<<<<<cr>', { desc = 'conflict' })
  vim.keymap.set('n', ']x', '/<<<<<<<<cr>', { desc = 'conflict' })
end

M.setup = function()
---@diagnostic disable-next-line: missing-fields
  require('git-conflict').setup {
    default_mappings = false,
    default_commands = true,
    disable_diagnostics = true,
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
