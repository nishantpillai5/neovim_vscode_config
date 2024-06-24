local plugins = {
  'tpope/vim-fugitive',
  'kdheepak/lazygit.nvim',
  'lewis6991/gitsigns.nvim',
  'sindrets/diffview.nvim',
  'linrongbin16/gitlinker.nvim',
  'akinsho/git-conflict.nvim',
  'polarmutex/git-worktree.nvim',
  'f-person/git-blame.nvim', --WARN: too flashy
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Git
  {
    'tpope/vim-fugitive',
    cond = conds['tpope/vim-fugitive'] or false,
    keys = {
      { '<leader>gs', desc = 'status' },
      { '<leader>gl', desc = 'log' },
    },
    config = require('config.fugitive').config,
  },
  -- Visual Git
  {
    'kdheepak/lazygit.nvim',
    cond = conds['kdheepak/lazygit.nvim'] or false,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gz', '<cmd>LazyGit<cr>', desc = 'lazygit' },
    },
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
  },
  -- Diff
  {
    'sindrets/diffview.nvim',
    cond = conds['sindrets/diffview.nvim'] or false,
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', desc = 'diff' },
      { '<leader>gD', desc = 'diff_from_main' },
      { '<leader>gH', desc = 'history' },
      { '<leader>gf', desc = 'file_diff' },
      { '<leader>gF', desc = 'file_diff_from_main' },
    },
    config = require('config.diffview').config,
  },
  -- Git sign column
  {
    'lewis6991/gitsigns.nvim',
    cond = conds['lewis6991/gitsigns.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      { '<leader>gB', desc = 'blame_buffer' },
    },
    config = require('config.gitsigns').config,
  },
  -- Open git link
  {
    'linrongbin16/gitlinker.nvim',
    cond = conds['linrongbin16/gitlinker.nvim'] or false,
    cmd = 'GitLink',
    -- TODO: incorrect commands
    keys = {
      { '<leader>goc', '<cmd>GitLink! blame<cr>', mode = { 'n', 'v' }, desc = 'commit' },
      { '<leader>gop', '<cmd>GitLink! blame<cr>', mode = { 'n', 'v' }, desc = 'pr' },
      { '<leader>goj', '<cmd>GitLink! blame<cr>', mode = { 'n', 'v' }, desc = 'jira' },
    },
    config = require('config.gitlinker').config,
  },
  -- Conflict
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    cond = conds['akinsho/git-conflict.nvim'] or false,
    keys = {
      { '[x', desc = 'conflict' },
      { ']x', desc = 'conflict' },
    },
    config = function()
      require('git-conflict').setup {
        default_mappings = false,
        default_commands = true,
        disable_diagnostics = true,
      }
      vim.keymap.set('n', '[x', '<Plug>(git-conflict-next-conflict)', { desc = 'conflict' })
      vim.keymap.set('n', ']x', '<Plug>(git-conflict-prev-conflict)', { desc = 'conflict' })
    end,
  },
  -- Worktree
  {
    'polarmutex/git-worktree.nvim',
    cond = conds['polarmutex/git-worktree.nvim'] or false,
    keys = {
      { '<leader>gw', desc = 'worktree_switch' },
      { '<leader>gW', desc = 'worktree_create' },
    },
    config = function()
      require('telescope').load_extension 'git_worktree'

      vim.keymap.set('n', '<leader>gw', function()
        require('telescope').extensions.git_worktree.git_worktrees()
        -- local dir = vim.fn.input('worktree name: ')
        -- require("git-worktree").switch_worktree(dir)
      end, { desc = 'worktree_switch' })

      vim.keymap.set('n', '<leader>gW', function()
        require('telescope').extensions.git_worktree.create_git_worktree()
        -- local branch = vim.fn.input('Branch name: ')
        -- local dir = vim.fn.input('worktree name: ')
        -- require("git-worktree").create_worktree(dir, branch, "origin")
      end, { desc = 'worktree_create' })
    end,
  },
  -- Statusline blame
  {
    'f-person/git-blame.nvim',
    cond = conds['f-person/git-blame.nvim'] or false,
    event = 'VeryLazy',
    config = require('config.gitblame').config,
  },
}
