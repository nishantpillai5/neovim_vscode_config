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
  if _G.whenNotifyLoaded ~= nil then
    _G.whenNotifyLoaded()
  end
end

-- M.config()

return M
