_G.custom_debug_log = _G.custom_debug_log or {}

local M = {}

M.cmd = {
  'SearchDebugPrints',
  'ToggleCommentDebugPrints',
  'DeleteDebugPrints',
  'ResetDebugPrintsCounter',
}

M.keys = {
  -- { '<leader>gco', mode = 'n', desc = 'obj' },
  -- { '<leader>gcO', mode = 'n', desc = 'obj_above' },
  { '<leader>gcc', mode = { 'n', 'x' }, desc = 'variable' },
  { '<leader>gcC', mode = { 'n', 'x' }, desc = 'variable_above' },
  { '<leader>gco', mode = 'n', desc = 'plain' },
  { '<leader>gcO', mode = 'n', desc = 'plain_above' },
  { '<leader>gcx', mode = 'n', desc = 'toggle' },
  { '<leader>gcX', mode = 'n', desc = 'debugprint_obj_above' },
  { '<leader>gcf', mode = 'n', desc = 'search' },
  { '<leader>gct', mode = 'n', desc = 'toggle' },
  { '<leader>gcd', mode = 'n', desc = 'delete' },
  { '<leader>gcr', mode = 'n', desc = 'reset' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>gcf', '<cmd>SearchDebugPrints<cr>', { desc = 'search' })
  set_keymap('n', '<leader>gct', '<cmd>ToggleCommentDebugPrints<cr>', { desc = 'toggle' })
  set_keymap('n', '<leader>gcd', '<cmd>DeleteDebugPrints<cr>', { desc = 'delete' })
  set_keymap('n', '<leader>gcr', '<cmd>ResetDebugPrintsCounter<cr>', { desc = 'reset' })
end

M.setup = function()
  _G.custom_debug_log = _G.custom_debug_log or {}
  require('debugprint').setup {
    filetypes = _G.custom_debug_log,
    keymaps = {
      normal = {
        -- textobj_below = '<leader>gco',
        -- textobj_above = '<leader>gcO',
        variable_below = '<leader>gcc',
        variable_above = '<leader>gcC',
        plain_below = '<leader>gco',
        plain_above = '<leader>gcO',
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
  M.keymaps()
end

-- M.config()

return M
