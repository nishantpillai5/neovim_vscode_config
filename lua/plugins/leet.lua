local plugins = {
  -- 'kawre/leetcode.nvim',
  'xeluxee/competitest.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)
local leet_arg = 'leet'

return {
  {
    'kawre/leetcode.nvim',
    lazy = leet_arg ~= vim.fn.argv()[1],
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-treesitter/nvim-treesitter',
      'rcarriga/nvim-notify',
      'nvim-tree/nvim-web-devicons',
    },
    cond = conds['kawre/leetcode.nvim'] or false,
    opts = { arg = leet_arg },
  },
  {
    'xeluxee/competitest.nvim',
    cond = conds['xeluxee/competitest.nvim'] or false,
    cmd = require('config.competitest').cmd,
    dependencies = { 'MunifTanjim/nui.nvim' },
    keys = require('config.competitest').keys,
    config = require('config.competitest').config,
  },
}
