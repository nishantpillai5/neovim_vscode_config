local M = {}

M.lualine = function()
  local lualineB = require('lualine').get_config().sections.lualine_b or {}
  table.insert(lualineB, { 'grapple' })

  require('lualine').setup { sections = { lualine_b = lualineB } }
end

M.setup = function()
  require('grapple').setup {
    scope = 'git',
    win_opts = {
      width = 0.8,
    },
    integrations = {
      resession = true,
    },
  }
end

M.config = function()
  M.setup()
  M.lualine()
end

-- M.config()

return M
