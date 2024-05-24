local plugins = {
  'Mofiqul/vscode.nvim',
  'petertriho/nvim-scrollbar',
  'kevinhwang91/nvim-hlslens',
  'nvim-zh/colorful-winsep.nvim',
  'utilyre/barbecue.nvim',
  'nvimdev/dashboard-nvim',
  'nvim-lualine/lualine.nvim',
  'letieu/harpoon-lualine',
  'lukas-reineke/indent-blankline.nvim',
  'rcarriga/nvim-notify',
  'folke/noice.nvim',
  'stevearc/dressing.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'Mofiqul/vscode.nvim',
    cond = conds['Mofiqul/vscode.nvim'] or false,
    lazy = false,
    priority = 1000,
    config = function()
      require('config.theme').setup()
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    cond = conds['petertriho/nvim-scrollbar'] or false,
    event = { 'BufReadPre' },
    config = function()
      local c = require('vscode.colors').get_colors()
      require('scrollbar').setup {
        handle = {
          color = c.vscPopupHighlightGray,
        },
        marks = {
            Search = { color = c.vscViolet },
            -- Error = { color = colors.error },
            -- Warn = { color = colors.warning },
            -- Info = { color = colors.info },
            -- Hint = { color = colors.hint },
            -- Misc = { color = colors.purple },
        },
      }
    end,
  },
  {
    'kevinhwang91/nvim-hlslens',
    cond = conds['kevinhwang91/nvim-hlslens'] or false,
    config = function()
      -- require('hlslens').setup() is not required
      require('scrollbar.handlers.search').setup {
        -- hlslens config overrides
      }
    end,
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    cond = conds['nvim-zh/colorful-winsep.nvim'] or false,
    event = { 'WinNew' },
    config = function()
      require('colorful-winsep').setup { smooth = false }
      require('config.theme').highlightSeparator 'n'
    end,
  },
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
      show_basename = false,
      show_dirname = false,
    },
  },
  {
    'nvimdev/dashboard-nvim',
    cond = conds['nvimdev/dashboard-nvim'] or false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    priority = 900,
    config = function()
      require('config.dashboard').setup()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    cond = conds['nvim-lualine/lualine.nvim'] or false,
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('config.lualine').setup()
    end,
  },
  {
    'letieu/harpoon-lualine',
    cond = conds['letieu/harpoon-lualine'] or false,
    event = 'VeryLazy',
    dependencies = {
      {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
      },
    },
  },
  -- Indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    cond = conds['lukas-reineke/indent-blankline.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
    config = function()
      require('config.indent_blankline').setup()
    end,
  },
  {
    'rcarriga/nvim-notify',
    cond = conds['rcarriga/nvim-notify'] or false,
    event = 'VeryLazy',
    config = function()
      require('notify').setup {
        stages = 'static',
        timeout = 2000,
        render = 'compact',
        top_down = false,
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
      'VonHeikemen/lsp-zero.nvim',
    },
    config = function()
      local config = require 'config.noice'
      config.setup()
      config.keymaps()
    end,
  },
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    cond = conds['stevearc/dressing.nvim'] or false,
    opts = {},
  },
}
