local plugins = {
  'tpope/vim-fugitive',
  'kdheepak/lazygit.nvim',
  'lewis6991/gitsigns.nvim',
  'sindrets/diffview.nvim',
  'linrongbin16/gitlinker.nvim',
  'akinsho/git-conflict.nvim',
  'polarmutex/git-worktree.nvim',
  'f-person/git-blame.nvim',
  'isakbm/gitgraph.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Git
  {
    'tpope/vim-fugitive',
    lazy = true,
    cond = conds['tpope/vim-fugitive'] or false,
    keys = require('config.fugitive').keys,
    config = require('config.fugitive').config,
  },
  -- Visual Git
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    cond = conds['kdheepak/lazygit.nvim'] or false,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    keys = {
      { '<leader>g\'', '<cmd>LazyGit<cr>', desc = 'lazygit' },
    },
  },
  -- Diff
  {
    'sindrets/diffview.nvim',
    lazy = true,
    cond = conds['sindrets/diffview.nvim'] or false,
    cmd = require('config.diffview').cmd,
    keys = require('config.diffview').keys,
    config = require('config.diffview').config,
  },
  -- Git sign column
  {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    cond = conds['lewis6991/gitsigns.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    keys = require('config.gitsigns').keys,
    config = require('config.gitsigns').config,
  },
  -- Open git link
  {
    'linrongbin16/gitlinker.nvim',
    lazy = true,
    cond = conds['linrongbin16/gitlinker.nvim'] or false,
    cmd = require('config.gitlinker').cmd,
    keys = require('config.gitlinker').keys,
    config = require('config.gitlinker').config,
  },
  -- Conflict
  {
    'akinsho/git-conflict.nvim',
    lazy = true,
    version = '*',
    cond = conds['akinsho/git-conflict.nvim'] or false,
    cmd = require('config.git_conflict').cmd,
    keys = require('config.git_conflict').keys,
    config = require('config.git_conflict').config,
  },
  -- Worktree
  {
    'polarmutex/git-worktree.nvim',
    lazy = true,
    version = '^2',
    dependencies = { 'nvim-lua/plenary.nvim', 'stevearc/overseer.nvim' },
    cond = conds['polarmutex/git-worktree.nvim'] or false,
    keys = require('config.git_worktree').keys,
    config = require('config.git_worktree').config,
  },
  -- Statusline blame
  {
    'f-person/git-blame.nvim',
    lazy = true,
    event = 'BufReadPost',
    cond = conds['f-person/git-blame.nvim'] or false,
    keys = require('config.gitblame').keys,
    config = require('config.gitblame').config,
  },
  -- Git graph
  {
    'isakbm/gitgraph.nvim',
    lazy = true,
    cond = conds['isakbm/gitgraph.nvim'] or false,
    dependencies = { 'sindrets/diffview.nvim' },
    keys = require('config.git_graph').keys,
    config = require('config.git_graph').config,
  },
}
