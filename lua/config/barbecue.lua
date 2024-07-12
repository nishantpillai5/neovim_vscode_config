local M = {}

M.setup = function()
  require('barbecue').setup {
    opts = {
      theme = {
        normal = { bg = '#262626' },
      },
      show_basename = true,
      show_dirname = false,
    }
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
