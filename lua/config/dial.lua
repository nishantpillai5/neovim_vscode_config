local M = {}
M.keys = {
  { '<C-a>', "<cmd>lua require('dial.map').manipulate('increment', 'normal')<cr>", desc = 'increment' },
  { '<C-x>', "<cmd>lua require('dial.map').manipulate('decrement', 'normal')<cr>", desc = 'decrement' },
}

M.setup = function()
  local augend = require 'dial.augend'
  require('dial.config').augends:register_group {
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.semver.alias.semver,
      augend.date.alias['%Y/%m/%d'],
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
