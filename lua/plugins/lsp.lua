local plugins = {
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-context',
  'code-biscuits/nvim-biscuits',
  'VonHeikemen/lsp-zero.nvim',
  'mfussenegger/nvim-lint',
  'stevearc/conform.nvim',
  'folke/trouble.nvim',
  'mtdl9/vim-log-highlighting',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    cond = conds['nvim-treesitter/nvim-treesitter'] or false,
    event = 'VeryLazy',
    build = ':TSUpdate',
    config = require('config.treesitter').config,
  },
  -- Code context
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cond = conds['nvim-treesitter/nvim-treesitter-context'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
  },
  -- Virtual context brackets
  {
    'code-biscuits/nvim-biscuits',
    cond = conds['code-biscuits/nvim-biscuits'] or false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      {
        '<leader>zc',
        function()
          local nvim_biscuits = require 'nvim-biscuits'
          nvim_biscuits.BufferAttach()
          nvim_biscuits.toggle_biscuits()
        end,
        mode = 'n',
        desc = 'context_virtual_toggle',
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
    config = require('config.lsp_zero').config,
  },
  -- Linter
  {
    'mfussenegger/nvim-lint',
    cond = conds['mfussenegger/nvim-lint'] or false,
    event = 'VeryLazy',
    dependencies = { 'VonHeikemen/lsp-zero.nvim' },
    config = require('config.lint').config,
  },
  -- Formatter
  {
    'zapling/mason-conform.nvim',
    cond = conds['stevearc/conform.nvim'] or false,
    dependencies = {
      'williamboman/mason.nvim',
      'stevearc/conform.nvim',
    },
    keys = {
      { '<leader>ls', mode = { 'n', 'v' }, desc = 'format' },
    },
    config = require('config.conform').config,
  },
  -- Diagnostic panel
  {
    'folke/trouble.nvim',
    cond = conds['folke/trouble.nvim'] or false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ft = { 'qf' },
    keys = {
      { '<leader>tt', desc = 'toggle' },
      { '<leader>td', desc = 'diagnostics' },
      { '<leader>tq', desc = 'quickfix' },
      { '<leader>tl', desc = 'loclist' },
      { '<leader>tg', desc = 'git' },
      { '<leader>tL', desc = 'lsp' },
      { '<leader>tf', desc = 'finder' },
      { '<leader>j', desc = 'trouble_next' },
      { '<leader>k', desc = 'trouble_prev' },
      { 'gr', desc = 'references' },
    },
    config = require('config.trouble').config,
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
