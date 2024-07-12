local M = {}

M.keys = {
  { '[x', desc = 'conflict' },
  { ']x', desc = 'conflict' },
}

M.keymaps = function()
  vim.keymap.set('n', '[x', '<cmd>GitConflictPrevConflict<cr>', { desc = 'conflict' })
  vim.keymap.set('n', ']x', '<cmd>GitConflictNextConflict<cr>', { desc = 'conflict' })
end

M.setup = function()
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
