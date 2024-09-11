local M = {}

M.keys = {
  { '<leader>A', '<cmd>Other<cr>', desc = 'alternate_file' },
}
M.setup = function()
  require('other-nvim').setup {
    mappings = {
      'c',
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
