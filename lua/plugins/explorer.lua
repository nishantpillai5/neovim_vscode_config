local plugins = {
  'nvim-neo-tree/neo-tree.nvim',
  'stevearc/oil.nvim',
  'liuchengxu/vista.vim',
  -- 'hedyhli/outline.nvim', -- WARN: too slow
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    lazy = true,
    -- event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    branch = 'v3.x',
    cond = conds['nvim-neo-tree/neo-tree.nvim'] or false,
    cmd = require('config.neotree').cmd,
    keys = require('config.neotree').keys,
    config = require('config.neotree').config,
  },
  -- Edit files as buffer
  {
    'stevearc/oil.nvim',
    lazy = true,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cond = conds['stevearc/oil.nvim'] or false,
    keys = require('config.oil').keys,
    config = require('config.oil').config,
  },
  -- Symbol explorer
  {
    'liuchengxu/vista.vim',
    lazy = true,
    cond = conds['liuchengxu/vista.vim'] or false,
    init = require('config.vista').init,
    cmd = require('config.vista').cmd,
    keys = require('config.vista').keys,
    config = require('config.vista').config,
  },
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cond = conds['hedyhli/outline.nvim'] or false,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { -- Example mapping to toggle outline
      { '<leader>es', '<cmd>topleft Outline!<CR>', desc = 'outline' },
    },
    opts = {},
  },
}
