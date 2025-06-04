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
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cond = conds['stevearc/oil.nvim'] or false,
    keys = {
      { '<leader>ef', '<cmd>Oil<cr>', desc = 'oil' },
    },
    opts = {
      -- Keep netrw enabled
      default_file_explorer = false,
    },
  },
  -- Symbol explorer
  {
    'liuchengxu/vista.vim',
    cond = conds['liuchengxu/vista.vim'] or false,
    keys = require('config.vista').keys,
    config = require('config.vista').config,
  },
  {
    'hedyhli/outline.nvim',
    cond = conds['hedyhli/outline.nvim'] or false,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { -- Example mapping to toggle outline
      { '<leader>es', '<cmd>topleft Outline!<CR>', desc = 'outline' },
    },
    opts = {
      -- Your setup opts here
    },
  },
}
