local plugins = {
  'aymericbeaumet/vim-symlink',
  'smartpde/neoscopes',
  'stevearc/resession.nvim',
  'ahmedkhalf/project.nvim',
  'klen/nvim-config-local',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Follow symlinks
  {
    'aymericbeaumet/vim-symlink',
    cond = conds['aymericbeaumet/vim-symlink'] or false,
    dependencies = { 'moll/vim-bbye' },
    event = 'VeryLazy',
  },
  -- Scoped finder
  {
    'smartpde/neoscopes',
    cond = conds['smartpde/neoscopes'] or false,
    keys = {
      { '<leader>ww', desc = 'select' },
      { '<leader>wx', desc = 'close' },
    },
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = require('config.neoscopes').config,
  },
  -- Session manager
  {
    'stevearc/resession.nvim',
    cond = conds['stevearc/resession.nvim'] or false,
    keys = {
      { '<leader>ws', desc = 'save_session' },
      { '<leader>wl', desc = 'load_session' },
      { '<leader>wS', desc = 'save_manual_session' },
      { '<leader>wL', desc = 'load_manual_session' },
      { '<leader>wd', desc = 'delete_session' },
    },
    config = require('config.recession').config,
  },
  -- Find other projects directories
  {
    'ahmedkhalf/project.nvim',
    cond = conds['ahmedkhalf/project.nvim'] or false,
    dependencies = { 'nvim-telescope/telescope.nvim' },
    -- lazy = true,
    event = "VeryLazy",
    config = function()
      require('project_nvim').setup()
      vim.keymap.set('n', '<leader>wf', function()
        require('telescope').extensions.projects.projects()
      end, { desc = 'find_project' })
    end,
  },
  -- Local config
  {
    'klen/nvim-config-local',
    cond = conds['klen/nvim-config-local'] or false,
    lazy = false,
    config = function()
      require('config-local').setup {
        config_files = { '.vscode/.nvim.lua', '.nvim.lua', '.nvimrc', '.exrc' },
        silent = true,
      }
    end,
  },
}
