local plugins = {
  'smartpde/neoscopes',
  'stevearc/resession.nvim',
  'aymericbeaumet/vim-symlink',
  'ahmedkhalf/project.nvim',
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
      { '<leader>ww', desc = 'Find.workspace' },
      { '<leader>wx', desc = 'Workspace.close' },
    },
    dependencies = { 'nvim-telescope/telescope.nvim' },
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
      { '<leader>ws', desc = 'Workspace.session_save' },
      { '<leader>wl', desc = 'Workspace.session_load' },
      { '<leader>wS', desc = 'Workspace.manual_session_save' },
      { '<leader>wL', desc = 'Workspace.manual_session_load' },
      { '<leader>wd', desc = 'Workspace.session_delete' },
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
    keys = {
      { '<leader>wf', desc = 'Workspace.find' },
    },
    config = function()
      require('project_nvim').setup()
      vim.keymap.set('n', '<leader>wf', function()
        require('telescope').extensions.projects.projects()
      end, { desc = 'Workspace.find' })
    end,
  },
}
