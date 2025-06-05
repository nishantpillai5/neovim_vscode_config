local plugins = {
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  -- 'mfussenegger/nvim-dap-python',
  'nvim-neotest/neotest',
  'Weissle/persistent-breakpoints.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    dependencies = {
      'ofirgall/goto-breakpoints.nvim',
      'stevearc/overseer.nvim',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-telescope/telescope-dap.nvim',
    },
    cond = conds['mfussenegger/nvim-dap'] or false,
    keys = require('config.dap').keys,
    config = require('config.dap').config,
  },
  {
    'rcarriga/nvim-dap-ui',
    lazy = true,
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    cond = conds['rcarriga/nvim-dap-ui'] or false,
    keys = require('config.dap_ui').keys,
    config = require('config.dap_ui').config,
  },
  {
    'mfussenegger/nvim-dap-python',
    lazy = true,
    dependencies = { 'mfussenegger/nvim-dap' },
    -- FIXME: load it on f5 on a python file
    -- event = 'BufEnter *.py',
    cond = conds['mfussenegger/nvim-dap-python'] or false,
    config = function()
      require('dap-python').setup(require('common.env').NVIM_PYTHON)
    end,
  },
  {
    'Weissle/persistent-breakpoints.nvim',
    lazy = true,
    -- event = 'VeryLazy',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['Weissle/persistent-breakpoints.nvim'] or false,
    keys = require('config.dap_breakpoints').keys,
    config = require('config.dap_breakpoints').config,
  },
  {
    'nvim-neotest/neotest',
    lazy = true,
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'stevearc/overseer.nvim',
      'alfaix/neotest-gtest',
      'nvim-neotest/neotest-python',
    },
    cond = conds['nvim-neotest/neotest'] or false,
    keys = require('config.neotest').keys,
    config = require('config.neotest').config,
  },
}
