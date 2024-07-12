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
}

local conds = require('common.lazy').get_conds(plugins)

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
    event = { 'BufReadPre' },
    cond = conds['petertriho/nvim-scrollbar'] or false,
    config = require('config.scrollbar').config,
  },
  -- Scrollbar search indicators
  {
    'kevinhwang91/nvim-hlslens',
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
    event = { 'BufReadPre' },
    cond = conds['nvim-zh/colorful-winsep.nvim'] or false,
    config = function()
      require('colorful-winsep').setup { smooth = false }
      require('config.theme').highlightSeparator 'n'
    end,
  },
  -- Context breadcrumbs
  {
    'utilyre/barbecue.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['utilyre/barbecue.nvim'] or false,
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    name = 'barbecue',
    version = '*',
    config = require('config.barbecue').config,
  },
  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    lazy = false,
    priority = 900,
    cond = conds['nvimdev/dashboard-nvim'] or false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require('config.dashboard').config,
  },
  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    cond = conds['nvim-lualine/lualine.nvim'] or false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = require('config.lualine').init,
    config = require('config.lualine').config,
  },
  -- Indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['lukas-reineke/indent-blankline.nvim'] or false,
    dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
    config = require('config.indent_blankline').config,
  },
  -- Better UI
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    cond = conds['rcarriga/nvim-notify'] or false,
    config = require('config.notify').config,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    cond = conds['folke/noice.nvim'] or false,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      -- 'VonHeikemen/lsp-zero.nvim',
    },
    config = require('config.noice').config,
  },
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    cond = conds['stevearc/dressing.nvim'] or false,
    opts = {},
  },
}
