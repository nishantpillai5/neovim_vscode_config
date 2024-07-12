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
    keys = require('config.dap').keys,
    config = require('config.dap').config,
  },
  {
    'rcarriga/nvim-dap-ui',
    cond = conds['rcarriga/nvim-dap-ui'] or false,
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    keys = require('config.dap_ui').keys,
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
