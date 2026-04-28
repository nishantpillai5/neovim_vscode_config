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
  { '<leader>cy', desc = 'diff_accept' },
  { '<leader>cn', desc = 'diff_reject' },
  { '<leader>cm', desc = 'model' },
  -- { '<leader>ce', mode = { 'n', 'v' }, desc = 'explain' },
  -- { '<leader>co', mode = { 'n', 'v' }, desc = 'optimize' },
  -- { '<leader>cd', mode = { 'n', 'v' }, desc = 'diagnostic_fix' },
  -- { '<leader>cD', mode = { 'n', 'v' }, desc = 'docs' },
  -- { '<leader>cg', mode = { 'n', 'v' }, desc = 'commit' },
  -- { '<leader>cG', mode = { 'n', 'v' }, desc = 'commit_staged' },
  -- { '<leader>cr', mode = { 'n', 'v' }, desc = 'review' },
  -- { '<leader>ci', mode = { 'n', 'v' }, desc = 'tests' },
  -- { '<leader>cx', desc = 'stop' },
  -- { '<leader>cX', desc = 'reset' },
  -- { '<leader>cb', desc = 'buffer' },
  -- { '<leader>cc', mode = 'v', desc = 'selection' },
  -- { '<leader>cs', mode = 'v', desc = 'simplify' },
  -- { '<leader>cp', mode = 'n', desc = 'pr_changes' },
  -- { '<leader>fc', mode = { 'n', 'v' }, desc = 'chat' },
  -- { '<leader>cf', mode = { 'n', 'v' }, desc = 'find' },
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
    vim.cmd 'ClaudeCode'
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