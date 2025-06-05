local plugins = {
  'rest-nvim/rest.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Test REST APIs
  {
    'rest-nvim/rest.nvim',
    lazy = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cond = conds['rest-nvim/rest.nvim'] or false,
    ft = 'http',
    config = require('config.rest').config,
  },
}
