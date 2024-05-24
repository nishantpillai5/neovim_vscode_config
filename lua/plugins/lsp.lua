local plugins = {
  'nvim-treesitter/nvim-treesitter',
  -- Context
  'nvim-treesitter/nvim-treesitter-context',
  'code-biscuits/nvim-biscuits',
  -- LSP
  'VonHeikemen/lsp-zero.nvim',
  -- Lint
  'mfussenegger/nvim-lint',
  -- Fomatter
  'stevearc/conform.nvim',
  -- Log Highlighting
  'mtdl9/vim-log-highlighting',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'nvim-treesitter/nvim-treesitter',
    cond = conds['nvim-treesitter/nvim-treesitter'] or false,
    event = 'VeryLazy',
    build = ':TSUpdate',
    config = function()
      require('config.treesitter').setup()
    end,
  },
  -- Context
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cond = conds['nvim-treesitter/nvim-treesitter-context'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'code-biscuits/nvim-biscuits',
    cond = conds['code-biscuits/nvim-biscuits'] or false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      {
        '<leader>zcc',
        function()
          local nvim_biscuits = require 'nvim-biscuits'
          nvim_biscuits.BufferAttach()
          nvim_biscuits.toggle_biscuits()
        end,
        mode = 'n',
        desc = 'Visual.Context.virtual',
      },
    },
    opts = {
      default_config = {
        prefix_string = '  ',
      },
    },
  },
  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    cond = conds['VonHeikemen/lsp-zero.nvim'] or false,
    event = 'VeryLazy',
    branch = 'v3.x',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      'folke/neodev.nvim',
    },
    config = function()
      local config = require 'config.lsp_zero'
      config.setup()
      config.keymaps()
      config.lualine()
    end,
  },
  -- Lint
  {
    'mfussenegger/nvim-lint',
    cond = conds['mfussenegger/nvim-lint'] or false,
    event = 'VeryLazy',
    dependencies = { 'VonHeikemen/lsp-zero.nvim' },
    config = function()
      local config = require 'config.lint'
      config.setup()
      config.lualine()
    end,
  },
  -- Fomatter
  {
    'zapling/mason-conform.nvim',
    cond = conds['stevearc/conform.nvim'] or false,
    dependencies = {
      'williamboman/mason.nvim',
      'stevearc/conform.nvim',
    },
    keys = {
      { '<leader>ls', mode = { 'n', 'v' }, desc = 'LSP.format' },
    },
    config = function()
      local config = require 'config.formatter'
      config.setup()
      config.keymaps()
    end,
  },
  -- Log Highlighting
  {
    'mtdl9/vim-log-highlighting',
    cond = conds['mtdl9/vim-log-highlighting'] or false,
    event = { 'BufReadPre *.log', 'BufNewFile *.log' },
    config = function()

      -- TODO: create syntax for [filename.c(1234)]
      -- vim.api.nvim_create_autocmd({ "Syntax" }, {
      --   -- pattern = { "*.log" },
      --   callback = function()
      --     vim.cmd("syn match logLevelError /\\[.*\\.c\\(*/")
      --   end,
      -- })
    end,
  },
}
