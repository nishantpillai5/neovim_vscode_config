local plugins = {
  'aymericbeaumet/vim-symlink',
  'smartpde/neoscopes',
  'stevearc/resession.nvim',
  'nvim-telescope/telescope-project.nvim',
  'klen/nvim-config-local',
  'xvzc/chezmoi.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Follow symlinks
  {
    'aymericbeaumet/vim-symlink',
    lazy = true,
    event = 'VeryLazy',
    dependencies = { 'moll/vim-bbye' },
    cond = conds['aymericbeaumet/vim-symlink'] or false,
  },
  -- Scoped finder
  {
    'smartpde/neoscopes',
    lazy = true,
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    cond = conds['smartpde/neoscopes'] or false,
    keys = require('config.neoscopes').keys,
    config = require('config.neoscopes').config,
  },
  -- Session manager
  {
    'stevearc/resession.nvim',
    lazy = true,
    cond = conds['stevearc/resession.nvim'] or false,
    dependencies = { 'cbochs/grapple.nvim' },
    keys = require('config.resession').keys,
    config = require('config.resession').config,
  },
  -- Find other project directories
  {
    'nvim-telescope/telescope-project.nvim',
    lazy = true,
    -- event = 'VeryLazy',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    cond = conds['nvim-telescope/telescope-project.nvim'] or false,
    keys = require('config.telescope_project').keys,
    config = require('config.telescope_project').config,
  },
  -- Local config
  {
    'klen/nvim-config-local',
    lazy = false,
    priority = 999,
    cond = conds['klen/nvim-config-local'] or false,
    config = function()
      require('config-local').setup {
        config_files = { '.vscode/.nvim.lua', '.nvim.lua', '.nvimrc', '.exrc' },
        silent = true,
      }
    end,
  },
  -- Global config
  {
    'xvzc/chezmoi.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>wC', desc = 'global_config' },
    },
    config = function()
      require('chezmoi').setup {
        -- your configurations
      }

      require('telescope').load_extension 'chezmoi'
      vim.keymap.set('n', '<leader>wC', require('telescope').extensions.chezmoi.find_files, { desc = "global_config" })
    end,
  },
}
