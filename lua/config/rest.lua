local M = {}

M.lualine = function()
  local lualineX = require('lualine').get_config().tabline.lualine_x or {}
  table.insert(lualineX, { 'rest' })

  require('lualine').setup { tabline = { lualine_x = lualineX } }
end

M.setup = function()
  require('rest-nvim').setup()
end

return M
