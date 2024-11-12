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
  -- set_keymap('n', '[x', '<cmd>GitConflictPrevConflict<cr>')
  -- set_keymap('n', ']x', '<cmd>GitConflictNextConflict<cr>')

  -- set_keymap('n', '[x', '<Plug>(git-conflict-prev-conflict)')
  -- set_keymap('n', ']x', '<Plug>(git-conflict-next-conflict)')
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>gxo', '<Plug>(git-conflict-ours)')
  set_keymap('n', '<leader>gxt', '<Plug>(git-conflict-theirs)')
  set_keymap('n', '<leader>gxb', '<Plug>(git-conflict-both)')
  set_keymap('n', '<leader>gxn', '<Plug>(git-conflict-none)')

  -- TODO: fix keymaps above are not working
  set_keymap('n', '[x', '?<<<<<<<<cr>')
  set_keymap('n', ']x', '/<<<<<<<<cr>')
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
