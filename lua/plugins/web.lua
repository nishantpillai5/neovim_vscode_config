local plugins = {
  -- 'vhyrro/luarocks.nvim',
  -- 'rest-nvim/rest.nvim'
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- for installing Luarocks dependencies
  {
    'vhyrro/luarocks.nvim',
    cond = conds['vhyrro/luarocks.nvim'] or false,
    priority = 1001,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
    }
  },
  -- Test REST APIs on nvim
  {
    "rest-nvim/rest.nvim",
    cond = conds['rest-nvim/rest.nvim'] or false,
    ft = "http",
    dependencies = { "luarocks.nvim" },
    config = function()
      local config = require("config.rest")
      config.setup()
      config.lualine()
    end,
  }
}
