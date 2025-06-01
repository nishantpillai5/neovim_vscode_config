local M = {}

M.keys = {
  { '<leader>rr', desc = 'refactor', mode = { 'n', 'x' } },
  { '<leader>re', desc = 'refactor_extract', mode = 'x' },
  { '<leader>rf', desc = 'refactor_extract_to_file', mode = 'x' },
  { '<leader>rv', desc = 'refactor_extract_var', mode = 'x' },
  { '<leader>ri', desc = 'refactor_inline_var', mode = { 'n', 'x' } },
  { '<leader>rI', desc = 'refactor_inline_func', mode = 'n' },
  { '<leader>rb', desc = 'refactor_extract_block', mode = 'n' },
  { '<leader>rB', desc = 'refactor_extract_block_to_file', mode = 'n' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap({ 'n', 'x' }, '<leader>rr', function()
    require('refactoring').select_refactor()
  end)
  set_keymap({ 'n', 'x' }, '<leader>re', function()
    return require('refactoring').refactor 'Extract Function'
  end, { expr = true })
  set_keymap({ 'n', 'x' }, '<leader>rf', function()
    return require('refactoring').refactor 'Extract Function To File'
  end, { expr = true })
  set_keymap({ 'n', 'x' }, '<leader>rv', function()
    return require('refactoring').refactor 'Extract Variable'
  end, { expr = true })
  set_keymap({ 'n', 'x' }, '<leader>rI', function()
    return require('refactoring').refactor 'Inline Function'
  end, { expr = true })
  set_keymap({ 'n', 'x' }, '<leader>ri', function()
    return require('refactoring').refactor 'Inline Variable'
  end, { expr = true })
  set_keymap({ 'n', 'x' }, '<leader>rbb', function()
    return require('refactoring').refactor 'Extract Block'
  end, { expr = true })
  set_keymap({ 'n', 'x' }, '<leader>rbf', function()
    return require('refactoring').refactor 'Extract Block To File'
  end, { expr = true })
end

M.setup = function()
  require('refactoring').setup {}
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
