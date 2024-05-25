local plugins = {
  'nvim-neo-tree/neo-tree.nvim',
  'stevearc/oil.nvim',
  'liuchengxu/vista.vim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    cond = conds['nvim-neo-tree/neo-tree.nvim'] or false,
    branch = 'v3.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    keys = {
      { '<leader>et', desc = 'Explorer.neotree' },
    },
    config = function()
      require('config.neotree').keymaps()
    end,
  },
  {
    'stevearc/oil.nvim',
    cond = conds['stevearc/oil.nvim'] or false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>ee', '<cmd>Oil<cr>', desc = 'Explorer.oil' },
    },
    config = function()
      require('oil').setup {
        -- Keep netrw enabled
        default_file_explorer = false,
      }
    end,
  },
  {
    'liuchengxu/vista.vim',
    cond = conds['liuchengxu/vista.vim'] or false,
    keys = {
      { '<leader>es', '<cmd>Vista!!<cr>', mode = 'n', desc = 'Explorer.symbols' },
    },
    config = function()
      require("config.vista").setup()
    end,
  },
}
