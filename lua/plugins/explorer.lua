local plugins = {
  'nvim-neo-tree/neo-tree.nvim',
  'stevearc/oil.nvim',
  'liuchengxu/vista.vim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    keys = require('config.neotree').keys,
    cond = conds['nvim-neo-tree/neo-tree.nvim'] or false,
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    branch = 'v3.x',
    config = require('config.neotree').config,
  },
  -- Edit files as buffer
  {
    'stevearc/oil.nvim',
    cond = conds['stevearc/oil.nvim'] or false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>ei', '<cmd>Oil<cr>', desc = 'oil' },
    },
    config = function()
      require('oil').setup {
        -- Keep netrw enabled
        default_file_explorer = false,
      }
    end,
  },
  -- Symbol explorer
  {
    'liuchengxu/vista.vim',
    keys = require('config.vista').keys,
    cond = conds['liuchengxu/vista.vim'] or false,
    config = require('config.vista').config,
  },
}
