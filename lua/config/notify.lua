_G.notify_loaded_callback = _G.notify_loaded_callback or nil

local M = {}

M.setup = function()
  require('notify').setup {
    stages = 'static',
    timeout = 2000,
    render = 'compact',
    top_down = true,
  }
  vim.notify = require 'notify'
end

M.config = function()
  M.setup()
  if _G.notify_loaded_callback ~= nil then
    _G.notify_loaded_callback()
  end
end

-- M.config()

return M
