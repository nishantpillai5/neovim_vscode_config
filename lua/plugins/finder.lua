local plugins = {
  'nvim-telescope/telescope.nvim',
  'OliverChao/telescope-picker-list.nvim',
  'ThePrimeagen/harpoon',
  'nvim-pack/nvim-spectre',
  'rgroli/other.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'nvim-telescope/telescope.nvim',
    cond = conds['nvim-telescope/telescope.nvim'] or false,
    event = 'VeryLazy',
    keys = {
      { '<leader>:', desc = 'find_commands' },
      { '<leader>ff', desc = 'Find.git_files' },
      { '<leader>fa', desc = 'Find.alternate' },
      { '<leader>fA', desc = 'Find.all' },
      { '<leader>fgs', desc = 'Find.Git.status' },
      { '<leader>fgb', desc = 'Find.Git.branch' },
      { '<leader>fgc', desc = 'Find.Git.commits' },
      { '<leader>fgz', desc = 'Find.Git.stash' },
      { '<leader>fl', desc = 'Find.Live_grep.global' },
      { '<leader>fL', desc = 'Find.Live_grep.global_with_args' },
      { '<leader>f/', desc = 'Find.Search.in_buffers' },
      { '<leader>f?', desc = 'Find.Search.global' },
      { '<leader>fw', desc = 'Find.word' },
      { '<leader>fW', desc = 'Find.whole_word' },
      { '<leader>F', desc = 'Find.telescope' },
      { '<leader>fs', desc = 'Find.symbols' },
      { '<leader>fm', desc = 'Find.marks' },
      { '<leader>fr', desc = 'Find.recents' },
      { '<leader>f"', desc = 'Find.registers' },
      { '<leader>fh', desc = 'Find.buffers' },
      -- { "<leader>fp", desc = "Find.yank" },
      { '<leader>fn', desc = 'Find.notes' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
    config = function()
      local config = require 'config.telescope'
      config.setup()
      config.keymaps()
    end,
  },
  {
    'OliverChao/telescope-picker-list.nvim',
    cond = conds['OliverChao/telescope-picker-list.nvim'] or false,
    dependencies = {
      'Snikimonkd/telescope-git-conflicts.nvim',
    },
    keys = {
      { '<leader>ft', desc = 'Find.telescope' },
    },
    config = function()
      local config = require 'config.telescope_picker'
      config.keymaps()
    end,
  },
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
    config = function()
      local config = require 'config.harpoon'
      config.setup()
      config.keymaps()
      config.lualine()
    end,
  },
  {
    'nvim-pack/nvim-spectre',
    cond = conds['nvim-pack/nvim-spectre'] or false,
    keys = {
      { '<leader>//', desc = 'Search.local' },
      { '<leader>/', desc = 'Search.global' },
      { '<leader>/w', desc = 'Search.global.word' },
    },
    config = function()
      local config = require 'config.spectre'
      config.keymaps()
    end,
  },
  {
    'rgroli/other.nvim',
    cond = conds['rgroli/other.nvim'] or false,
    keys = {
      { '<leader>A', desc = 'alternate_file' },
    },
    config = function()
      require('other-nvim').setup {
        mappings = {
          'c',
        },
      }
    vim.api.nvim_set_keymap("n", "<leader>A", "<cmd>Other<CR>", { noremap = true, silent = true })
    end,
  },
}
