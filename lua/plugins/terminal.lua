local plugins = {
  'akinsho/nvim-toggleterm.lua',
  'ryanmsnyder/toggleterm-manager.nvim',
  'stevearc/overseer.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Panel
  {
    'akinsho/nvim-toggleterm.lua',
    cond = conds['akinsho/nvim-toggleterm.lua'] or false,
    keys = {
      { '<leader>;;', desc = 'Terminal.toggle' },
    },
    config = function()
      local config = require 'config.toggleterm'
      config.setup()
      config.keymaps()
    end,
  },
  -- Manager
  {
    'ryanmsnyder/toggleterm-manager.nvim',
    cond = conds['ryanmsnyder/toggleterm-manager.nvim'] or false,
    dependencies = {
      'akinsho/nvim-toggleterm.lua',
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>f;', desc = 'Find.terminal' },
      { '<leader>;f', desc = 'Terminal.find' },
    },
    config = function()
      local config = require 'config.toggleterm_manager'
      config.setup()
      config.keymaps()
    end,
  },
  -- Tasks
  {
    'stevearc/overseer.nvim',
    cond = conds['stevearc/overseer.nvim'] or false,
    dependencies = {
      'akinsho/nvim-toggleterm.lua',
      'nvim-telescope/telescope.nvim',
      'stevearc/dressing.nvim',
    },
    keys = {
      { '<leader>oo', desc = 'Tasks.run_from_list' },
      { '<leader>eo', desc = 'Explorer.tasks' },
      { '<leader>ot', desc = 'Tasks.toggle' },
      { '<leader>ol', desc = 'Tasks.last_restart' },
      { '<leader>or', desc = 'Tasks.run' },
      { '<leader>ob', desc = 'Tasks.build' },
    },
    config = function()
      local config = require 'config.overseer'
      config.setup()
      config.keymaps()
      config.lualine()
    end,
  },
}
