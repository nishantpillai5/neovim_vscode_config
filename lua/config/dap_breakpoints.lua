local M = {}

M.keys = {
  { 'mb', desc = 'breakpoint' },
  { 'mB', desc = 'breakpoint_conditional' },
}

M.keymaps = function()
  vim.api.nvim_set_keymap(
    'n',
    'mb',
    "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>",
    { desc = 'breakpoint' }
  ) -- :PBToggleBreakpoint
  vim.api.nvim_set_keymap(
    'n',
    'mB',
    "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>",
    { desc = 'breakpoint_conditional' }
  ) -- :PBSetConditionalBreakpoint
  -- vim.api.nvim_set_keymap('n', '<YourKey3>', "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts) -- :PBClearAllBreakpoints
  -- vim.api.nvim_set_keymap('n', '<YourKey4>', "<cmd>lua require('persistent-breakpoints.api').set_log_point()<cr>", opts) -- :PBSetLogPoint
end

M.setup = function()
  require('persistent-breakpoints').setup {
    load_breakpoints_event = { 'BufReadPost' },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M