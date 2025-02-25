local M = {}

M.setup = function()
  require('barbecue').setup {
    theme = {
      basename = { bold = true },
    },
    show_basename = true,
    show_dirname = false,
    show_navic = false,
    show_modified = true,
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
