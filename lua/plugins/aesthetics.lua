local plugins = {
  'Mofiqul/vscode.nvim',
  'petertriho/nvim-scrollbar',
  'kevinhwang91/nvim-hlslens',
  'nvim-zh/colorful-winsep.nvim',
  'utilyre/barbecue.nvim',
  'nvimdev/dashboard-nvim',
  'nvim-lualine/lualine.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'rcarriga/nvim-notify',
  'folke/noice.nvim',
  'stevearc/dressing.nvim',
  'folke/edgy.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Colorscheme
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority = 1000,
    cond = conds['Mofiqul/vscode.nvim'] or false,
    config = require('config.theme').config,
  },
  -- Scrollbar
  {
    'petertriho/nvim-scrollbar',
    lazy = true,
    event = { 'BufReadPre' },
    cond = conds['petertriho/nvim-scrollbar'] or false,
    config = require('config.scrollbar').config,
  },
  -- Scrollbar search indicators
  {
    'kevinhwang91/nvim-hlslens',
    lazy = true,
    event = { 'BufReadPre' },
    cond = conds['kevinhwang91/nvim-hlslens'] or false,
    config = function()
      require('scrollbar.handlers.search').setup {
        override_lens = function() end,
      }
    end,
  },
  -- Windows Separator
  {
    'nvim-zh/colorful-winsep.nvim',
    lazy = true,
    event = { 'WinLeave' },
    cond = conds['nvim-zh/colorful-winsep.nvim'] or false,
    config = function()
      require('colorful-winsep').setup {
        animate = {
          enabled = false,
        },
      }
      require('config.theme').highlightSeparator 'n'
    end,
  },
  -- Filename in winbar
  {
    'utilyre/barbecue.nvim',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    name = 'barbecue',
    version = '*',
    cond = conds['utilyre/barbecue.nvim'] or false,
    config = require('config.barbecue').config,
  },
  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    lazy = false,
    priority = 700,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cond = conds['nvimdev/dashboard-nvim'] or false,
    config = require('config.dashboard').config,
  },
  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    lazy = true,
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- dependencies = { 'nvim-tree/nvim-web-devicons', 'tpope/vim-fugitive' },
    cond = conds['nvim-lualine/lualine.nvim'] or false,
    init = require('config.lualine').init,
    config = require('config.lualine').config,
  },
  -- Indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
    cond = conds['lukas-reineke/indent-blankline.nvim'] or false,
    config = require('config.indent_blankline').config,
  },
  -- Notifications
  {
    'rcarriga/nvim-notify',
    lazy = true,
    event = 'VeryLazy',
    cond = conds['rcarriga/nvim-notify'] or false,
    config = require('config.notify').config,
  },
  {
    'folke/noice.nvim',
    lazy = true,
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      -- 'VonHeikemen/lsp-zero.nvim',
    },
    cond = conds['folke/noice.nvim'] or false,
    config = require('config.noice').config,
  },
  -- Improved UI components TODO: replace with snacks.nvim
  {
    'stevearc/dressing.nvim',
    lazy = true,
    event = 'VeryLazy',
    cond = conds['stevearc/dressing.nvim'] or false,
    opts = {},
  },
  -- Window layouts
  {
    'folke/edgy.nvim',
    lazy = true,
    cond = conds['folke/edgy.nvim'] or false,
    event = 'VeryLazy',
    keys = require('config.edgy').keys,
    config = require('config.edgy').config,
  },
}
