local M = {}

M.cmd = {
  'Grapple',
}

M.keys = {
  { '<leader>a', '<cmd>Grapple toggle<cr>', desc = 'grapple_add' },
  { '<leader>h', '<cmd>Grapple toggle_tags<cr>', desc = 'grapple_list' },
  { '<C-PageUp>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'grapple_prev' },
  { '<C-PageDown>', '<cmd>Grapple cycle_tags next<cr>', desc = 'grapple_next' },
}

M.lualine = function()
  local lualineA = require('lualine').get_config().tabline.lualine_a or {}
  table.insert(lualineA, { 'grapple' })

  require('lualine').setup { tabline = { lualine_a = lualineA } }
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
