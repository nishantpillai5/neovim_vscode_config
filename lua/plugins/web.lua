local plugins = {
  -- 'rest-nvim/rest.nvim'
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Test REST APIs on nvim
  {
    'rest-nvim/rest.nvim',
    dependencies = { 'luarocks.nvim' },
    cond = conds['rest-nvim/rest.nvim'] or false,
    ft = 'http',
    config = require('config.rest').config,
  },
}
