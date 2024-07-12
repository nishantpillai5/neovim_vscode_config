local plugins = {
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  -- 'mfussenegger/nvim-dap-python',
}

local conds = require('common.utils').get_conds_table(plugins)
local HOME = require('common.env').HOME

return {
  {
    'mfussenegger/nvim-dap',
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
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    cond = conds['rcarriga/nvim-dap-ui'] or false,
    keys = require('config.dap_ui').keys,
    config = require('config.dap_ui').config,
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = { 'mfussenegger/nvim-dap' },
    -- FIXME: load it on f5 on a python file
    -- event = 'BufEnter *.py',
    cond = conds['mfussenegger/nvim-dap-python'] or false,
    config = function()
      require('dap-python').setup(HOME .. '/.virtualenvs/debugpy/Scripts/python')
    end,
  },
}
