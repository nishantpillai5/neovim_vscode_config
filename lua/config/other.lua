_G.other_mappings = _G.other_mappings or nil

local M = {}

M.keys_all = {
  { '<leader>A', '<cmd>Other<cr>', desc = 'alternate_file', vsc_cmd = 'alt8.findRelatedFiles' },
}

M.keys = require('common.utils').filter_keymap(M.keys_all)

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
