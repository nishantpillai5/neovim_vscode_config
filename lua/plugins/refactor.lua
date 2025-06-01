local plugins = {
  'smjonas/inc-rename.nvim',
  'ThePrimeagen/refactoring.nvim',
  'nvim-pack/nvim-spectre',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Refactor
  {
    'smjonas/inc-rename.nvim',
    cond = conds['smjonas/inc-rename.nvim'] or false,
    keys = require('config.increname').keys,
    config = require('config.increname').config,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    cond = conds['ThePrimeagen/refactoring.nvim'] or false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = require('config.refactoring').keys,
    config = require('config.refactoring').config,
  },
  -- Find and replace
  {
    'nvim-pack/nvim-spectre',
    cond = conds['nvim-pack/nvim-spectre'] or false,
    keys = require('config.spectre').keys,
    config = require('config.spectre').config,
  },
}
