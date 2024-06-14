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
      { '<leader>ff', desc = 'Find.git_files' },
      { '<leader>fF', desc = 'Find.ignored_files' },
      { '<leader>fa', desc = 'Find.alternate' },
      { '<leader>fA', desc = 'Find.all' },
      { '<leader>fgs', desc = 'Find.Git.status' },
      { '<leader>fgb', desc = 'Find.Git.branch' },
      { '<leader>fgc', desc = 'Find.Git.commits' },
      { '<leader>fgz', desc = 'Find.Git.stash' },
      { '<leader>fl', desc = 'Find.live_grep.global' },
      { '<leader>fL', desc = 'Find.live_grep.global_with_args' },
      { '<leader>/', desc = 'find_local' },
      { '<leader>?', desc = 'find_global' },
      { '<leader>fw', desc = 'Find.word' },
      { '<leader>fW', desc = 'Find.whole_word' },
      { '<leader>Ff', desc = 'Find_Telescope.builtin' },
      { '<leader>fs', desc = 'Find.symbols' },
      { '<leader>fm', desc = 'Find.marks' },
      { '<leader>fr', desc = 'Find.recents' },
      { '<leader>f"', desc = 'Find.registers' },
      { '<leader>fh', desc = 'Find.buffers' },
      -- { "<leader>fp", desc = "Find.yank" },
      { '<leader>fn', desc = 'Find.notes' },
      { '<leader>wc', desc = 'Workspace.configurations' },
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
      { '<leader>Fe', desc = 'Find_Telescope.extensions' },
    },
    config = require('config.telescope_picker').config,
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
