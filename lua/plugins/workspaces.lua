local plugins = {
  'aymericbeaumet/vim-symlink',
  'smartpde/neoscopes',
  'stevearc/resession.nvim',
  'nvim-telescope/telescope-project.nvim',
  'klen/nvim-config-local',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Follow symlinks
  {
    'aymericbeaumet/vim-symlink',
    event = 'VeryLazy',
    dependencies = { 'moll/vim-bbye' },
    cond = conds['aymericbeaumet/vim-symlink'] or false,
  },
  -- Scoped finder
  {
    'smartpde/neoscopes',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    cond = conds['smartpde/neoscopes'] or false,
    keys = require('config.neoscopes').keys,
    config = require('config.neoscopes').config,
  },
  -- Session manager
  {
    'stevearc/resession.nvim',
    cond = conds['stevearc/resession.nvim'] or false,
    dependencies = { 'cbochs/grapple.nvim' },
    keys = require('config.resession').keys,
    config = require('config.resession').config,
  },
  -- Find other project directories
  {
    'nvim-telescope/telescope-project.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    cond = conds['nvim-telescope/telescope-project.nvim'] or false,
    keys = {
      { '<leader>wW', desc = 'select_project' },
    },
    config = function()
      local set_keymap = require('common.utils').get_keymap_setter()
      set_keymap('n', '<leader>wW', function()
        require('telescope').extensions.project.project()
      end, { desc = 'select_project' })
    end,
  },
  -- Local config
  {
    'klen/nvim-config-local',
    priority = 999,
    lazy = false,
    cond = conds['klen/nvim-config-local'] or false,
    config = function()
      require('config-local').setup {
        config_files = { '.vscode/.nvim.lua', '.nvim.lua', '.nvimrc', '.exrc' },
        silent = true,
      }
    end,
  },
}
