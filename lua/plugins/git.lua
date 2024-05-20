local plugins = {
  'tpope/vim-fugitive',
  'kdheepak/lazygit.nvim',
  'lewis6991/gitsigns.nvim',
  'sindrets/diffview.nvim',
  'linrongbin16/gitlinker.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'tpope/vim-fugitive',
    cond = conds['tpope/vim-fugitive'] or false,
    keys = {
      { '<leader>gs', desc = 'Git.status' },
      { '<leader>gl', desc = 'Git.log' },
      { '<leader>gB', desc = 'Git.blame_buffer' },
    },
    config = function()
      require('config.fugitive').setup()
      require('config.fugitive').keymaps()
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    cond = conds['kdheepak/lazygit.nvim'] or false,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gz', '<cmd>LazyGit<cr>', desc = 'Git.lazygit' },
    },
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
  },
  {
    'sindrets/diffview.nvim',
    cond = conds['sindrets/diffview.nvim'] or false,
    keys = {
      { '<leader>gd', desc = 'Git.diff_global' },
      { '<leader>gf', desc = 'Git.file_history' },
    },
    config = function()
      require('config.diffview').keymaps()
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    cond = conds['lewis6991/gitsigns.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('config.gitsigns').setup()
    end,
  },
  {
    'linrongbin16/gitlinker.nvim',
    cond = conds['linrongbin16/gitlinker.nvim'] or false,
    cmd = 'GitLink',
    keys = {
      { '<leader>gy', '<cmd>GitLink blame<cr>', mode = { 'n', 'v' }, desc = 'Git.yank_link' },
      { '<leader>gY', '<cmd>GitLink! blame<cr>', mode = { 'n', 'v' }, desc = 'Git.open_link' },
    },
    opts = {},
  },
}
