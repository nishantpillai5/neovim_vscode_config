local plugins = {
  'nvim-telescope/telescope.nvim',
  'OliverChao/telescope-picker-list.nvim',
  'axkirillov/easypick.nvim',
  'jemag/telescope-diff.nvim',
  'cbochs/grapple.nvim',
  'rgroli/other.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Finder
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-live-grep-args.nvim',
      'paopaol/telescope-git-diffs.nvim',
    },
    cond = conds['nvim-telescope/telescope.nvim'] or false,
    keys = require('config.telescope').keys,
    config = require('config.telescope').config,
  },
  -- Finder extensions
  {
    'OliverChao/telescope-picker-list.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'Snikimonkd/telescope-git-conflicts.nvim',
      'xiyaowong/telescope-emoji.nvim',
      '2KAbhishek/nerdy.nvim',
      'jemag/telescope-diff.nvim',
    },
    cond = conds['OliverChao/telescope-picker-list.nvim'] or false,
    keys = require('config.telescope_picker').keys,
    config = require('config.telescope_picker').config,
  },
  {
    'axkirillov/easypick.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    cond = conds['axkirillov/easypick.nvim'] or false,
    cmd = require('config.easypick').cmd,
    keys = require('config.easypick').keys,
    config = require('config.easypick').config,
  },
  {
    'jemag/telescope-diff.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    cond = conds['jemag/telescope-diff.nvim'] or false,
    keys = require('config.telescope_diff').keys,
    config = require('config.telescope_diff').config,
  },
  -- Buffer navigation
  {
    'cbochs/grapple.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cond = conds['cbochs/grapple.nvim'] or false,
    cmd = require('config.grapple').cmd,
    keys = require('config.grapple').keys,
    config = require('config.grapple').config,
  },
  -- Change to alternate file
  {
    'rgroli/other.nvim',
    cond = conds['rgroli/other.nvim'] or false,
    keys = require('config.other').keys,
    config = require('config.other').config,
  },
}
