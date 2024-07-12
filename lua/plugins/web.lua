local plugins = {
  -- 'vhyrro/luarocks.nvim',
  -- 'rest-nvim/rest.nvim'
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- for installing Luarocks dependencies
  {
    'vhyrro/luarocks.nvim',
    priority = 1001,
    cond = conds['vhyrro/luarocks.nvim'] or false,
    config = true,
    opts = {
      rocks = { 'lua-curl', 'nvim-nio', 'mimetypes', 'xml2lua' },
    },
  },
  -- Test REST APIs on nvim
  {
    'rest-nvim/rest.nvim',
    dependencies = { 'luarocks.nvim' },
    cond = conds['rest-nvim/rest.nvim'] or false,
    ft = 'http',
    config = require('config.rest').config,
  },
}
