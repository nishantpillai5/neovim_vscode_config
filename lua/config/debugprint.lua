_G.custom_debug_log = _G.custom_debug_log or {}

local M = {}

M.keys = {
  { '<leader>gc', mode = 'n', desc = 'obj' },
  { '<leader>gC', mode = 'n', desc = 'obj_above' },
  { '<leader>gcc', mode = { 'n', 'x' }, desc = 'variable' },
  { '<leader>gcC', mode = { 'n', 'x' }, desc = 'variable_above' },
  { '<leader>gcp', mode = 'n', desc = 'plain' },
  { '<leader>gcP', mode = 'n', desc = 'plain_above' },
  { '<leader>gcx', mode = 'n', desc = 'toggle' },
  { '<leader>gcX', mode = 'n', desc = 'debugprint_obj_above' },
}

M.setup = function()
  _G.custom_debug_log = _G.custom_debug_log or {}
  require('debugprint').setup {
    filetypes = _G.custom_debug_log,
    keymaps = {
      normal = {
        textobj_below = '<leader>gc',
        textobj_above = '<leader>gC',
        variable_below = '<leader>gcc',
        variable_above = '<leader>gcC',
        plain_below = '<leader>gcp',
        plain_above = '<leader>gcP',
        toggle_comment_debug_prints = '<leader>gcx',
        delete_debug_prints = '<leader>gcX',
        variable_below_alwaysprompt = nil,
        variable_above_alwaysprompt = nil,
      },
      visual = {
        variable_below = '<leader>gcc',
        variable_above = '<leader>gcC',
      },
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
