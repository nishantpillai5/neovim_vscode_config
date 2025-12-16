local plugins = {
  'akinsho/nvim-toggleterm.lua',
  'nishantpillai5/toggleterm-manager.nvim',
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
    lazy = true,
    keys = require('config.toggleterm').keys,
    config = require('config.toggleterm').config,
  },
  -- Manager
  {
    'nishantpillai5/toggleterm-manager.nvim', -- forked to create terminals with env vars
    cond = conds['nishantpillai5/toggleterm-manager.nvim'] or false,
    lazy = true,
    dependencies = {
      'akinsho/nvim-toggleterm.lua',
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    keys = require('config.toggleterm_manager').keys,
    config = require('config.toggleterm_manager').config,
  },
  -- Tasks
  {
    'stevearc/overseer.nvim',
    cond = conds['stevearc/overseer.nvim'] or false,
    lazy = true,
    version = '^1.6.0', -- FIXME: https://github.com/stevearc/overseer.nvim/pull/448
    dependencies = {
      'akinsho/nvim-toggleterm.lua',
      'nvim-telescope/telescope.nvim',
      'stevearc/dressing.nvim',
    },
    cmd = require('config.overseer').cmd,
    keys = require('config.overseer').keys,
    config = require('config.overseer').config,
  },
  -- Coverage
  {
    'andythigpen/nvim-coverage',
    cond = conds['andythigpen/nvim-coverage'] or false,
    lazy = true,
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
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
    cond = conds['pianocomposer321/officer.nvim'] or false,
    lazy = true,
    dependencies = { 'stevearc/overseer.nvim' },
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
    lazy = true,
    cmd = { 'Nredir' },
    keys = {
      { '<leader>oRR', ':Nredir !', desc = 'run_cmd_to_buffer' },
    },
  },
}
