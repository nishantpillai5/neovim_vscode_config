local plugins = {
  'akinsho/nvim-toggleterm.lua',
  'ryanmsnyder/toggleterm-manager.nvim',
  'stevearc/overseer.nvim',
  'sbulav/nredir.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Panel
  {
    'akinsho/nvim-toggleterm.lua',
    cond = conds['akinsho/nvim-toggleterm.lua'] or false,
    keys = {
      { '<leader>;;', desc = 'toggle' },
    },
    config = require('config.toggleterm').config,
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
      { '<leader>f;', desc = 'terminal' },
      { '<leader>;f', desc = 'find' },
    },
    config = require('config.toggleterm_manager').config,
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
      { '<leader>oo', desc = 'run_from_list' },
      { '<leader>eo', desc = 'tasks' },
      { '<leader>ot', desc = 'toggle' },
      { '<leader>oc', desc = 'change_last' },
      { '<leader>ol', desc = 'restart_last' },
      { '<leader>op', desc = 'preview_last' },
      { '<leader>ox', desc = 'stop_last' },
      { '<leader>oX', desc = 'stop_all' },
      { '<leader>or', desc = 'run' },
      { '<leader>ob', desc = 'build' },
    },
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
