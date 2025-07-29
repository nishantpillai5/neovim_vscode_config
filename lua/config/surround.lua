local M = {}

M.keys = {
  { '<leader>v', desc = 'surround' },
  { '<leader>Vd', desc = 'delete' },
  { '<leader>Vf', desc = 'find' },
  { '<leader>VF', desc = 'find_left' },

  { '<leader>Vh', desc = 'highlight' },
  { '<leader>Vr', desc = 'replace' },
  { '<leader>Vn', desc = 'update_n_lines' },
}

M.setup = function()
  require('mini.surround').setup {
    search_method = 'cover_or_nearest',
    mappings = {
      add = '<leader>v',
      delete = '<leader>Vd',
      find = '<leader>Vf',
      find_left = '<leader>VF',
      highlight = '<leader>Vh',
      replace = '<leader>Vr',
      update_n_lines = '<leader>Vn',
      suffix_last = 'l',
      suffix_next = 'n',
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
