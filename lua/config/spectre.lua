local M = {}

M.keys_all = {
  { '<leader>r/', desc = 'spectre_local', mode = { 'n', 'v' }, vsc_cmd = 'search.action.replaceAllInFile' },
  { '<leader>r?', desc = 'spectre_global', vsc_cmd = 'workbench.action.replaceInFiles' },
  { '<leader>rw', desc = 'spectre_global_word', mode = { 'n', 'v' } },
}
M.keys = require('common.utils').filter_keymap(M.keys_all)

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
