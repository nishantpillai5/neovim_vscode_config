local plugins = {
  'akinsho/nvim-toggleterm.lua',
  'ryanmsnyder/toggleterm-manager.nvim',
  'stevearc/overseer.nvim',
  'andythigpen/nvim-coverage',
  'pianocomposer321/officer.nvim',
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
    cmd = require('config.overseer').cmd,
    keys = require('config.overseer').keys,
    config = require('config.overseer').config,
  },
  -- Coverage
  {
    'andythigpen/nvim-coverage',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cond = conds['andythigpen/nvim-coverage'] or false,
    cmd = {
      'Coverage',
      'CoverageLoad',
      'CoverageLoadLcov',
      'CoverageShow',
      'CoverageHide',
      'CoverageToggle',
      'CoverageClear',
      'CoverageSummary',
    },
    config = function()
      require('coverage').setup {
        auto_reload = true,
      }
    end,
  },
  -- Build task using makeprg
  {
    'pianocomposer321/officer.nvim',
    dependencies = { 'stevearc/overseer.nvim' },
    cond = conds['pianocomposer321/officer.nvim'] or false,
    cmd = { 'Make', 'Run' },
    config = function()
      -- TODO: If you set `:set makeprg=pytest\ %`, running `:make` will run `pytest` on the current file.
      require('officer').setup {
        create_mappings = false,
      }
    end,
  },
  -- Redir commands to buffer
  {
    'sbulav/nredir.nvim',
    cond = conds['sbulav/nredir.nvim'] or false,
    cmd = { 'Nredir' },
    keys = {
      { '<leader>oR', ':Nredir !', desc = 'run_cmd_to_buffer' },
    },
  },
}
