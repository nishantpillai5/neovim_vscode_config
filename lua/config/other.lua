_G.other_mappings = _G.other_mappings or nil

local M = {}

M.keys = {
  { '<leader>A', '<cmd>Other<cr>', desc = 'alternate_file' },
}
M.setup = function()
  local mappings = { 'c' }
  vim.list_extend(mappings, _G.other_mappings or {})

  require('other-nvim').setup {
    mappings = mappings,
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
