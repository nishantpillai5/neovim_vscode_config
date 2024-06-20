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
    cond = conds['nvim-neo-tree/neo-tree.nvim'] or false,
    branch = 'v3.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    keys = {
      { '<leader>ee', desc = 'neotree' },
      { '<leader>eb', desc = 'buffers' },
      { '<leader>eg', desc = 'git' },
      { '<leader>ex', desc = 'toggle' },
    },
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
    cond = conds['liuchengxu/vista.vim'] or false,
    keys = {
      { '<leader>es', '<cmd>Vista!!<cr>', mode = 'n', desc = 'symbols' },
    },
    config = require('config.vista').config,
  },
}
