local plugins = {
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-context',
  'code-biscuits/nvim-biscuits',
  'VonHeikemen/lsp-zero.nvim',
  'mfussenegger/nvim-lint',
  'stevearc/conform.nvim',
  'folke/trouble.nvim',
  'mtdl9/vim-log-highlighting',
  'folke/lazydev.nvim',
  'Bilal2453/luvit-meta',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    cond = conds['nvim-treesitter/nvim-treesitter'] or false,
    build = ':TSUpdate',
    config = require('config.treesitter').config,
  },
  -- Code context
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      { '<leader>zc', '<cmd>TSContextToggle<CR>', mode = 'n', desc = 'context_sticky' },
    },
    cond = conds['nvim-treesitter/nvim-treesitter-context'] or false,
  },
  -- Virtual context brackets
  {
    'code-biscuits/nvim-biscuits',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cond = conds['code-biscuits/nvim-biscuits'] or false,
    keys = {
      {
        '<leader>zC',
        function()
          local nvim_biscuits = require 'nvim-biscuits'
          nvim_biscuits.BufferAttach()
          nvim_biscuits.toggle_biscuits()
        end,
        mode = 'n',
        desc = 'context_virtual',
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
    event = 'VeryLazy',
    -- event = { 'BufReadPre', 'BufNewFile' },
    branch = 'v3.x',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/nvim-cmp',
      'rcarriga/cmp-dap',
      {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
      },
      'saadparwaiz1/cmp_luasnip',
      'dmitmel/cmp-cmdline-history',
    },
    keys = require('config.lsp_zero').keys,
    cond = conds['VonHeikemen/lsp-zero.nvim'] or false,
    config = require('config.lsp_zero').config,
  },
  -- Linter
  {
    'mfussenegger/nvim-lint',
    -- event = 'VeryLazy',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'VonHeikemen/lsp-zero.nvim' },
    cond = conds['mfussenegger/nvim-lint'] or false,
    config = require('config.lint').config,
  },
  -- Formatter
  {
    'zapling/mason-conform.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'stevearc/conform.nvim',
    },
    cond = conds['stevearc/conform.nvim'] or false,
    keys = require('config.conform').keys,
    config = require('config.conform').config,
  },
  -- Diagnostic panel
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ft = { 'qf' },
    cond = conds['folke/trouble.nvim'] or false,
    keys = require('config.trouble').keys,
    config = require('config.trouble').config,
  },
  -- Log Highlighting
  {
    'mtdl9/vim-log-highlighting',
    event = { 'BufReadPre *.log', 'BufNewFile *.log' },
    cond = conds['mtdl9/vim-log-highlighting'] or false,
  },
  -- Lua nvim lazy lsp
  {
    'folke/lazydev.nvim',
    cond = conds['folke/lazydev.nvim'] or false,
    ft = 'lua',
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'Bilal2453/luvit-meta',
    cond = conds['Bilal2453/luvit-meta'] or false,
    lazy = true,
  }, -- optional `vim.uv` typings
}
