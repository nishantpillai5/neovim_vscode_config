local M = {}

M.keys = {
  { '<leader>li', mode = 'n', desc = 'ignore_rule' },
  { '<leader>lI', mode = { 'n', 'x' }, desc = 'ignore_formatter' },
  { '<leader>lF', mode = 'n', desc = 'lookup_diagnostic_code' },
  { '<leader>lY', mode = 'n', desc = 'yank_diagnostic_code' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>li', function()
    require('rulebook').ignoreRule()
  end)

  set_keymap({ 'n', 'x' }, '<leader>lI', function()
    require('rulebook').suppressFormatter()
  end)

  set_keymap('n', '<leader>lF', function()
    require('rulebook').lookupRule()
  end)

  set_keymap('n', '<leader>lY', function()
    require('rulebook').yankDiagnosticCode()
  end)
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
