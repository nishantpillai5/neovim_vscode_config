local plugins = {
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  -- 'mfussenegger/nvim-dap-python',
}

local conds = require('common.lazy').get_conds(plugins)
local HOME = require('common.env').HOME

return {
  {
    'mfussenegger/nvim-dap',
    cond = conds['mfussenegger/nvim-dap'] or false,
    dependencies = {
      'ofirgall/goto-breakpoints.nvim',
      'stevearc/overseer.nvim',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-telescope/telescope-dap.nvim',
    },
    keys = {
      { '<F5>', desc = 'Debug.continue/start' },
      { '<C-F5>', desc = 'Debug.stop' },
      { '<F6>', desc = 'Debug.pause' },
      { '<F7>', desc = 'Debug.step_into' },
      { '<C-F7>', desc = 'Debug.step_out' },
      { '<F8>', desc = 'Debug.step_over' },
      { '<leader>bb', desc = 'toggle' },
      { '<leader>bl', desc = 'toggle_with_log' },
      { '[b', desc = 'breakpoint' },
      { ']b', desc = 'breakpoint' },
      { '<leader>fbb', desc = 'Breakpoint' },
      { '<leader>fbc', desc = 'configurations' },
      { '<leader>fbv', desc = 'variables' },
      { '<leader>fbf', desc = 'frames' },
      { '<leader>zb', '<cmd>DapVirualTextToggle<cr>', desc = 'debug_text_toggle' },
    },
    config = require('config.dap').config,
  },
  {
    'rcarriga/nvim-dap-ui',
    cond = conds['rcarriga/nvim-dap-ui'] or false,
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    keys = {
      { '<leader>bt', desc = 'toggle_view' },
      { '<leader>bK', desc = 'hover' },
      -- { "<leader>bK", "<cmd>lua require('dap.ui.variables').visual_hover()<cr>", mode = "v", desc = "Breakpoint.hover" },
      -- { "<leader>b?", "<cmd>lua require('dap.ui.variables').scopes()<cr>", mode = "v", desc = "Breakpoint.hover" },
    },
    config = require('config.dap_ui').config,
  },
  {
    'mfussenegger/nvim-dap-python',
    cond = conds['mfussenegger/nvim-dap-python'] or false,
    dependencies = { 'mfussenegger/nvim-dap' },
    -- FIXME: load it on f5 on a python file
    -- event = 'BufEnter *.py',
    config = function()
      require('dap-python').setup(HOME .. '/.virtualenvs/debugpy/Scripts/python')
    end,
  },
}
