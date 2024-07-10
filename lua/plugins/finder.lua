local plugins = {
  'nvim-telescope/telescope.nvim',
  'OliverChao/telescope-picker-list.nvim',
  'axkirillov/easypick.nvim',
  'jemag/telescope-diff.nvim',
  'cbochs/grapple.nvim',
  'rgroli/other.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Finder
  {
    'nvim-telescope/telescope.nvim',
    cond = conds['nvim-telescope/telescope.nvim'] or false,
    event = 'VeryLazy',
    keys = require('config.telescope').keys,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-live-grep-args.nvim',
      'paopaol/telescope-git-diffs.nvim',
    },
    config = require('config.telescope').config,
  },
  -- Finder extensions
  {
    'OliverChao/telescope-picker-list.nvim',
    cond = conds['OliverChao/telescope-picker-list.nvim'] or false,
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'Snikimonkd/telescope-git-conflicts.nvim',
      'xiyaowong/telescope-emoji.nvim',
      '2KAbhishek/nerdy.nvim',
      'jemag/telescope-diff.nvim',
    },
    keys = {
      { '<leader>Fe', desc = 'extensions' },
    },
    config = require('config.telescope_picker').config,
  },
  {
    'axkirillov/easypick.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    keys = require('config.easypick').keys,
    cmd = require('config.easypick').cmds,
    config = require('config.easypick').config,
  },
  {
    'jemag/telescope-diff.nvim',
    keys = {
      { '<leader>ed', desc = 'diff_file_current' },
      { '<leader>eD', desc = 'diff_file_select_both' },
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>ed', function()
        require('telescope').extensions.diff.diff_current { hidden = true }
      end, { desc = 'diff_file_current' })

      vim.keymap.set('n', '<leader>eD', function()
        require('telescope').extensions.diff.diff_files { hidden = true }
      end, { desc = 'diff_file_select_both' })
    end,
  },
  -- Buffer navigation
  {
    'cbochs/grapple.nvim',
    cond = conds['cbochs/grapple.nvim'] or false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    keys = {
      { '<leader>a', '<cmd>Grapple toggle<cr>', desc = 'grapple_add' },
      { '<leader>h', '<cmd>Grapple toggle_tags<cr>', desc = 'grapple_list' },
      { '<C-PageUp>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'grapple_prev' },
      { '<C-PageDown>', '<cmd>Grapple cycle_tags next<cr>', desc = 'grapple_next' },
    },
    config = require('config.grapple').config,
  },
  -- Change to alternate file
  {
    'rgroli/other.nvim',
    cond = conds['rgroli/other.nvim'] or false,
    keys = {
      { '<leader>A', '<cmd>Other<cr>', desc = 'alternate_file' },
    },
    config = function()
      require('other-nvim').setup {
        mappings = {
          'c',
        },
      }
    end,
  },
}
