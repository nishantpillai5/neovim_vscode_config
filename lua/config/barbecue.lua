local M = {}

M.setup = function()
  require('barbecue').setup {
    -- theme = {
    --   normal = { bg = '#262626' },
    -- },
    show_basename = false,
    show_dirname = false,
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
