_G.other_mappings = _G.other_mappings or nil

local M = {}

M.keys = {
  { '<leader>A', '<cmd>Other<cr>', desc = 'alternate_file' },
}
M.setup = function()
  require('other-nvim').setup {
    mappings = vim.tbl_deep_extend('force', { 'c' }, _G.other_mappings),
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
