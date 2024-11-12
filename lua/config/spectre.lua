local M = {}

M.keys = {
  { '<leader>r/', desc = 'local' },
  { '<leader>r?', desc = 'global' },
  { '<leader>rw', desc = 'global_word' },
}

M.keymaps = function()
  local spectre = require 'spectre'
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>r/', function()
    spectre.open_file_search()
  end)

  set_keymap('v', '<leader>r/', function()
    spectre.open_file_search { select_word = true }
  end)

  set_keymap('n', '<leader>r?', function()
    spectre.toggle()
  end)

  set_keymap('n', '<leader>rw', function()
    spectre.open_visual { select_word = true }
  end)

  set_keymap('v', '<leader>rw', function()
    spectre.open_visual()
  end)
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
