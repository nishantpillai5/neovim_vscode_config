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
    cond = conds['tpope/vim-fugitive'] or false,
    keys = require('config.fugitive').keys,
    config = require('config.fugitive').config,
  },
  -- Visual Git
  {
    'kdheepak/lazygit.nvim',
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
      { '<leader>g;', '<cmd>LazyGit<cr>', desc = 'lazygit' },
    },
  },
  -- Diff
  {
    'sindrets/diffview.nvim',
    cond = conds['sindrets/diffview.nvim'] or false,
    cmd = require('config.diffview').cmd,
    keys = require('config.diffview').keys,
    config = require('config.diffview').config,
  },
  -- Git sign column
  {
    'lewis6991/gitsigns.nvim',
    cond = conds['lewis6991/gitsigns.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    keys = require('config.gitsigns').keys,
    config = require('config.gitsigns').config,
  },
  -- Open git link
  {
    'linrongbin16/gitlinker.nvim',
    cond = conds['linrongbin16/gitlinker.nvim'] or false,
    cmd = require('config.gitlinker').cmd,
    keys = require('config.gitlinker').keys,
    config = require('config.gitlinker').config,
  },
  -- Conflict
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    cond = conds['akinsho/git-conflict.nvim'] or false,
    cmd = require('config.git_conflict').cmd,
    keys = require('config.git_conflict').keys,
    config = require('config.git_conflict').config,
  },
  -- Worktree
  {
    'polarmutex/git-worktree.nvim',
    version = '^2',
    dependencies = { 'nvim-lua/plenary.nvim', 'stevearc/overseer.nvim' },
    cond = conds['polarmutex/git-worktree.nvim'] or false,
    keys = require('config.git_worktree').keys,
    config = require('config.git_worktree').config,
  },
  -- Statusline blame
  {
    'f-person/git-blame.nvim',
    -- event = 'VeryLazy',
    event = 'BufReadPost',
    cond = conds['f-person/git-blame.nvim'] or false,
    keys = require('config.gitblame').keys,
    config = require('config.gitblame').config,
  },
  {
    'isakbm/gitgraph.nvim',
    cond = conds['isakbm/gitgraph.nvim'] or false,
            dependencies = { 'sindrets/diffview.nvim' },
    opts = {
      symbols = {
        merge_commit = 'M',
        commit = '*',
      },
      format = {
        timestamp = '%H:%M:%S %d-%m-%Y',
        fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
      },
      hooks = {
        -- Check diff of a commit
        on_select_commit = function(commit)
          vim.notify('DiffviewOpen ' .. commit.hash .. '^!')
          vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
        end,
        -- Check diff from commit a -> commit b
        on_select_range_commit = function(from, to)
          vim.notify('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
          vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
        end,

      },
    },
    keys = {
      {
        '<leader>gG',
        function()
          require('gitgraph').draw({}, { all = true, max_count = 5000 })
        end,
        desc = 'graph',
      },
    },
  },
}
