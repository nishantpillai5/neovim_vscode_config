local plugins = {
  'nvim-telescope/telescope.nvim',
  'OliverChao/telescope-picker-list.nvim',
  'ThePrimeagen/harpoon',
  'rgroli/other.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Finder
  {
    'nvim-telescope/telescope.nvim',
    cond = conds['nvim-telescope/telescope.nvim'] or false,
    event = 'VeryLazy',
    keys = {
      { '<leader>:', desc = 'find_commands' },
      { '<leader>ff', desc = 'git_files' },
      { '<leader>fF', desc = 'ignored_files' },
      { '<leader>fa', desc = 'all' },
      { '<leader>fA', desc = 'alternate' },
      { '<leader>fgs', desc = 'status' },
      { '<leader>fgb', desc = 'branch' },
      { '<leader>fgc', desc = 'commits' },
      { '<leader>fgz', desc = 'stash' },
      { '<leader>fgx', desc = 'conflicts' },
      { '<leader>fl', desc = 'live_grep_global' },
      { '<leader>fL', desc = 'live_grep_global_with_args' },
      { '<leader>/', desc = 'find_local' },
      { '<leader>?', desc = 'find_global' },
      { '<leader>fw', desc = 'word' },
      { '<leader>fW', desc = 'whole_word' },
      { '<leader>Ff', desc = 'builtin' },
      { '<leader>fs', desc = 'symbols' },
      { '<leader>fm', desc = 'marks' },
      { '<leader>fr', desc = 'recents' },
      { '<leader>f"', desc = 'registers' },
      { '<leader>fh', desc = 'buffers' },
      -- { "<leader>fp", desc = "yank" },
      { '<leader>fn', desc = 'notes' },
      { '<leader>nf', desc = 'notes' },
      { '<leader>wc', desc = 'configurations' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-live-grep-args.nvim',
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
    "jemag/telescope-diff.nvim",
    keys = {
      { '<leader>ed', desc = 'diff_file_current' },
      { '<leader>eD', desc = 'diff_file_select_both' },
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>ed", function()
        require("telescope").extensions.diff.diff_current({hidden=true})
      end, { desc = "diff_file_current" })

      vim.keymap.set("n", "<leader>eD", function()
        require("telescope").extensions.diff.diff_files({hidden=true})
      end, { desc = "diff_file_select_both" })
    end
  },
  -- Buffer navigation
  {
    'ThePrimeagen/harpoon',
    cond = conds['ThePrimeagen/harpoon'] or false,
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      { '<leader>a', desc = 'harpoon_add' },
      { '<leader>h', desc = 'harpoon_list' },
      { '<C-PageUp>', desc = 'harpoon_prev' },
      { '<C-PageDown>', desc = 'harpoon_next' },
    },
    config = require('config.harpoon').config,
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
