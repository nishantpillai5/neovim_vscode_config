local M = {}

M.setup = function()
  require('barbecue').setup {
    -- theme = {
    --   normal = { bg = '#262626' },
    -- },
    show_basename = require('common.env').SCREEN == 'widescreen',
    show_dirname = require('common.env').SCREEN == 'widescreen',
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
