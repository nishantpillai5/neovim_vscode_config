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
    cond = conds['Mofiqul/vscode.nvim'] or false,
    lazy = false,
    priority = 1000,
    config = require('config.theme').config,
  },
  -- Scrollbar
  {
    'petertriho/nvim-scrollbar',
    cond = conds['petertriho/nvim-scrollbar'] or false,
    event = { 'BufReadPre' },
    config = require('config.scrollbar').config,
  },
  -- Scrollbar search indicators
  {
    'kevinhwang91/nvim-hlslens',
    cond = conds['kevinhwang91/nvim-hlslens'] or false,
    event = { 'BufReadPre' },
    config = function()
      require('scrollbar.handlers.search').setup {
        override_lens = function() end,
      }
    end,
  },
  -- Windows Separator
  {
    'nvim-zh/colorful-winsep.nvim',
    cond = conds['nvim-zh/colorful-winsep.nvim'] or false,
    event = { 'BufReadPre' },
    config = function()
      require('colorful-winsep').setup { smooth = false }
      require('config.theme').highlightSeparator 'n'
    end,
  },
  -- Context breadcrumbs
  {
    'utilyre/barbecue.nvim',
    cond = conds['utilyre/barbecue.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      theme = {
        normal = { bg = '#262626' },
      },
      show_basename = true,
      show_dirname = false,
    },
  },
  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    cond = conds['nvimdev/dashboard-nvim'] or false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    priority = 900,
    config = require('config.dashboard').config,
  },
  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    cond = conds['nvim-lualine/lualine.nvim'] or false,
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = require('config.lualine').init,
    config = require('config.lualine').config,
  },
  -- Indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    cond = conds['lukas-reineke/indent-blankline.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
    config = require('config.indent_blankline').config,
  },
  -- Better UI
  {
    'rcarriga/nvim-notify',
    cond = conds['rcarriga/nvim-notify'] or false,
    event = 'VeryLazy',
    config = function()
      require('notify').setup {
        stages = 'static',
        timeout = 2000,
        render = 'compact',
        top_down = true,
      }
      vim.notify = require 'notify'
    end,
  },
  {
    'folke/noice.nvim',
    cond = conds['folke/noice.nvim'] or false,
    event = 'VeryLazy',
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
