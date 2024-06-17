local plugins = {
  'tpope/vim-fugitive',
  'kdheepak/lazygit.nvim',
  'lewis6991/gitsigns.nvim',
  'sindrets/diffview.nvim',
  'linrongbin16/gitlinker.nvim',
  'akinsho/git-conflict.nvim',
  'ThePrimeagen/git-worktree.nvim',
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
      { '<leader>gB', desc = 'blame_buffer' },
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
    cmd = { 'DiffviewOpen', "DiffviewFileHistory" },
    keys = {
      { '<leader>gd', desc = 'diff' },
      { '<leader>gD', desc = 'history_file' },
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
    'ThePrimeagen/git-worktree.nvim',
    cond = conds['ThePrimeagen/git-worktree.nvim'] or false,
    keys = {
      { '<leader>fgw', desc = 'worktree_switch' },
      { '<leader>fgW', desc = 'worktree_create' },
    },
    config = function()
      vim.keymap.set('n', '<leader>fgw', function()
        require('telescope').extensions.git_worktree.git_worktrees()
      end, { desc = 'worktree_switch' })

      vim.keymap.set('n', '<leader>fgW', function()
        require('telescope').extensions.git_worktree.create_git_worktree()
      end, { desc = 'worktree_create' })
    end,
  },
}
