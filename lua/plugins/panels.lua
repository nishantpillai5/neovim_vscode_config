local plugins = {
  'folke/trouble.nvim',
  'akinsho/nvim-toggleterm.lua',
  'ryanmsnyder/toggleterm-manager.nvim',
  'stevearc/overseer.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'folke/trouble.nvim',
    cond = conds['folke/trouble.nvim'] or false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>tt', desc = 'Trouble.toggle' },
      { '<leader>tw', desc = 'Trouble.workspace_diagnostics' },
      { '<leader>td', desc = 'Trouble.document_diagnostics' },
      { '<leader>tq', desc = 'Trouble.quickfix' },
      { '<leader>tl', desc = 'Trouble.loclist' },
      { '<leader>tg', desc = 'Trouble.git' },
      { '<leader>j', desc = 'trouble_next' },
      { '<leader>k', desc = 'trouble_prev' },
      { 'gr', desc = 'references' },
    },
    config = function()
      local config = require 'config.trouble'
      config.keymaps()
    end,
  },
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
    },
    config = function()
      local config = require 'config.toggleterm_manager'
      config.setup()
      config.keymaps()
    end,
  },
  {
    'stevearc/overseer.nvim',
    cond = conds['stevearc/overseer.nvim'] or false,
    dependencies = {
      'akinsho/nvim-toggleterm.lua',
      'nvim-telescope/telescope.nvim',
      'stevearc/dressing.nvim',
    },
    keys = {
      { '<leader>oo', desc = 'Tasks.run' },
      { '<leader>eo', desc = 'Explorer.tasks' },
      { '<leader>ot', desc = 'Tasks.toggle' },
      { '<leader>ol', desc = 'Tasks.restart_last' },
    },
    config = function()
      local config = require 'config.overseer'
      config.setup()
      config.keymaps()
      config.lualine()
    end,
  },
}
