local plugins = {
  'akinsho/nvim-toggleterm.lua',
  'ryanmsnyder/toggleterm-manager.nvim',
  'stevearc/overseer.nvim',
  'sbulav/nredir.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Panel
  {
    'akinsho/nvim-toggleterm.lua',
    cond = conds['akinsho/nvim-toggleterm.lua'] or false,
    keys = require('config.toggleterm').keys,
    config = require('config.toggleterm').config,
  },
  -- Manager
  {
    'ryanmsnyder/toggleterm-manager.nvim',
    dependencies = {
      'akinsho/nvim-toggleterm.lua',
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    cond = conds['ryanmsnyder/toggleterm-manager.nvim'] or false,
    keys = require('config.toggleterm_manager').keys,
    config = require('config.toggleterm_manager').config,
  },
  -- Tasks
  {
    'stevearc/overseer.nvim',
    dependencies = {
      'akinsho/nvim-toggleterm.lua',
      'nvim-telescope/telescope.nvim',
      'stevearc/dressing.nvim',
    },
    cond = conds['stevearc/overseer.nvim'] or false,
    keys = require('config.overseer').keys,
    config = require('config.overseer').config,
  },
  -- Redir commands to buffer
  {
    'sbulav/nredir.nvim',
    cond = conds['sbulav/nredir.nvim'] or false,
    cmd = { 'Nredir' },
    keys = {
      { '<leader>O', ':Nredir !', desc = 'run_cmd' },
    },
  },
}
