local plugins = {
  'smartpde/neoscopes',
  'stevearc/resession.nvim',
  'aymericbeaumet/vim-symlink',
  'ahmedkhalf/project.nvim',
  'klen/nvim-config-local',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'aymericbeaumet/vim-symlink',
    cond = conds['aymericbeaumet/vim-symlink'] or false,
    dependencies = { 'moll/vim-bbye' },
    event = 'VeryLazy',
  },
  {
    'smartpde/neoscopes',
    cond = conds['smartpde/neoscopes'] or false,
    keys = {
      { '<leader>ww', desc = 'Workspace.select' },
      { '<leader>wx', desc = 'Workspace.close' },
    },
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      local config = require 'config.neoscopes'
      config.keymaps()
      config.lualine()
    end,
  },
  {
    'stevearc/resession.nvim',
    cond = conds['stevearc/resession.nvim'] or false,
    keys = {
      { '<leader>ws', desc = 'Workspace.save_session' },
      { '<leader>wl', desc = 'Workspace.load_session' },
      { '<leader>wS', desc = 'Workspace.save_manual_session' },
      { '<leader>wL', desc = 'Workspace.load_manual_session' },
      { '<leader>wd', desc = 'Workspace.delete_session' },
    },

    config = function()
      local config = require 'config.session'
      config.setup()
      config.keymaps()
    end,
  },
  {
    'ahmedkhalf/project.nvim',
    cond = conds['ahmedkhalf/project.nvim'] or false,
    dependencies = { 'nvim-telescope/telescope.nvim' },
    lazy = false,
    config = function()
      require('project_nvim').setup()
      vim.keymap.set('n', '<leader>wf', function()
        require('telescope').extensions.projects.projects()
      end, { desc = 'Workspace.find_project' })
    end,
  },
  {
    'klen/nvim-config-local',
    cond = conds['klen/nvim-config-local'] or false,
    lazy = false,
    -- TODO: late sourcing, load after loading all plugins so that lsp can be configured
    config = function()
      require('config-local').setup {
        config_files = { '.vscode/.nvim.lua', '.nvim.lua', '.nvimrc', '.exrc' },
        silent = true,
      }
    end,
  },
}
