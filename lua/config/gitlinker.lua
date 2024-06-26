local M = {}

M.setup = function()
  require('gitlinker').setup(_G.gitlinker_config)
end

M.config = function()
  M.setup()
end

-- M.config()

return M
