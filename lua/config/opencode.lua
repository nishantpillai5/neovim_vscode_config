local M = {}

M.keys = {
  { '<leader>aa', desc = 'chat', mode = { 'n', 'x' } },
  { '<leader>av', desc = 'attach_visual', mode = 'v' },
  { '<leader>aV', desc = 'attach_buffer' },
  {
    '<leader>av',
    '<cmd>ClaudeCodeTreeAdd<cr>',
    desc = 'attach_file',
    ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
  },
  { '<leader>as', desc = 'session_continue' },
  { '<leader>af', desc = 'find_session' },
  { '<leader>aF', desc = 'find_session_cmd' },
  { '<leader>aj', desc = 'diff_accept' },
  { '<leader>ak', desc = 'diff_reject' },
  { '<leader>am', desc = 'model' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap({ 'n', 'v' }, '<leader>aa', function()
    require('opencode').toggle()
  end)
  set_keymap('v', '<leader>av', function()
    vim.cmd 'ClaudeCodeSend'
  end)
  set_keymap('n', '<leader>aV', function()
    vim.cmd 'ClaudeCodeAdd %'
  end)
  set_keymap('n', '<leader>as', function()
    vim.cmd 'ClaudeCode --continue'
  end)
  set_keymap('n', '<leader>af', pick_claude_session)
  set_keymap('n', '<leader>aF', function()
    vim.cmd 'ClaudeCode --resume'
  end)
  set_keymap('n', '<leader>aj', function()
    vim.cmd 'ClaudeCodeDiffAccept'
  end)
  set_keymap('n', '<leader>ak', function()
    vim.cmd 'ClaudeCodeDiffDeny'
  end)
  set_keymap('n', '<leader>am', function()
    vim.cmd 'ClaudeCodeSelectModel'
  end)

  -- -- Recommended/example keymaps
  -- vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
  --   require('opencode').ask('@this: ', { submit = true })
  -- end, { desc = 'Ask opencode…' })
  -- vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
  --   require('opencode').select()
  -- end, { desc = 'Execute opencode action…' })
  -- vim.keymap.set({ 'n', 't' }, '<C-.>', function()
  --   require('opencode').toggle()
  -- end, { desc = 'Toggle opencode' })
  --
  -- vim.keymap.set({ 'n', 'x' }, 'go', function()
  --   return require('opencode').operator '@this '
  -- end, { desc = 'Add range to opencode', expr = true })
  -- vim.keymap.set('n', 'goo', function()
  --   return require('opencode').operator '@this ' .. '_'
  -- end, { desc = 'Add line to opencode', expr = true })
  --
  -- vim.keymap.set('n', '<S-C-u>', function()
  --   require('opencode').command 'session.half.page.up'
  -- end, { desc = 'Scroll opencode up' })
  -- vim.keymap.set('n', '<S-C-d>', function()
  --   require('opencode').command 'session.half.page.down'
  -- end, { desc = 'Scroll opencode down' })
  --
  -- -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
end

M.setup = function()
  vim.g.opencode_opts = {
    -- Your configuration, if any; goto definition on the type or field for details
  }
  -- require('claudecode').setup()
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M