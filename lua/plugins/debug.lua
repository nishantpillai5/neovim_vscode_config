local plugins = {
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  'mfussenegger/nvim-dap-python',
}

local conds = require('common.lazy').get_conds(plugins)

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
      { '<leader>bb', desc = 'Breakpoint.toggle' },
      { '<leader>bl', desc = 'Breakpoint.toggle_with_log' },
      { '[b', desc = 'Prev.breakpoint' },
      { ']b', desc = 'Next.breakpoint' },
      { 'fbb', desc = 'Find.Breakpoint' },
      { 'fbc', desc = 'Find.Breakpoint.configurations' },
      { 'fbv', desc = 'Find.Breakpoint.variables' },
      { 'fbf', desc = 'Find.Breakpoint.frames' },
      -- { "<leader>bt", desc = "Debug.toggle" },
      -- { "<leader>zd","<cmd>DapVirualTextToggle<cr>", desc = "Visual.debug_virtual_toggle" }, -- TODO: doesn't hide, just stops refreshing
    },
    config = function()
      local config = require 'config.dap'
      config.setup()
      config.keymaps()
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    cond = conds['rcarriga/nvim-dap-ui'] or false,
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    keys = {
      { '<leader>bt', desc = 'Breakpoint.toggle_view' },
      { '<leader>bK', desc = 'Breakpoint.hover' },
      -- { "<leader>bK", "<cmd>lua require('dap.ui.variables').visual_hover()<cr>", mode = "v", desc = "Breakpoint.hover" },
      -- { "<leader>b?", "<cmd>lua require('dap.ui.variables').scopes()<cr>", mode = "v", desc = "Breakpoint.hover" },
    },
    config = function()
      require('config.dap_ui').setup()
      require('config.dap_ui').keymaps()
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    cond = conds['mfussenegger/nvim-dap-python'] or false,
    dependencies = { 'mfussenegger/nvim-dap' },
    event = 'BufEnter *.py',
    config = function()
      require('dap-python').setup(os.getenv 'HOME' .. '/.virtualenvs/debugpy/Scripts/python')
    end,
  },
}
