local M = {}

M.keys = {
  { '<leader>ca', desc = 'attach_selection', mode = 'v' },
  {
    '<leader>ca',
    '<cmd>ClaudeCodeTreeAdd<cr>',
    desc = 'Add file',
    ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
  },
  { '<leader>cA', desc = 'attach_buffer' },
  { '<leader>cc', desc = 'chat' },
  { '<leader>cC', desc = 'continue' },
  { '<leader>cf', desc = 'find_session' },
  { '<leader>fc', desc = 'chat' },
  { '<leader>cy', desc = 'diff_accept' },
  { '<leader>cn', desc = 'diff_reject' },
  { '<leader>cm', desc = 'model' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('v', '<leader>ca', function()
    vim.cmd 'ClaudeCodeSend'
  end)

  set_keymap('n', '<leader>cA', function()
    vim.cmd 'ClaudeCodeAdd %'
  end)

  set_keymap('n', '<leader>cc', function()
    vim.cmd 'ClaudeCodeFocus'
  end)

  set_keymap('n', '<leader>cC', function()
    vim.cmd 'ClaudeCode --continue'
  end)

  set_keymap('n', '<leader>cf', function()
    vim.cmd 'ClaudeCode --resume'
  end)

  set_keymap('n', '<leader>fc', function()
    vim.cmd 'ClaudeCode --resume'
  end)

  set_keymap('n', '<leader>cy', function()
    vim.cmd 'ClaudeCodeDiffAccept'
  end)

  set_keymap('n', '<leader>cn', function()
    vim.cmd 'ClaudeCodeDiffDeny'
  end)

  set_keymap('n', '<leader>cm', function()
    vim.cmd 'ClaudeCodeSelectModel'
  end)
end

M.setup = function()
  require('claudecode').setup()
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M