local M = {}

M.keymaps = function()
  local spectre = require 'spectre'

  vim.keymap.set('n', '<leader>r/', function()
    spectre.open_file_search()
  end, { desc = 'local' })

  vim.keymap.set('v', '<leader>r/', function()
    spectre.open_file_search { select_word = true }
  end, { desc = 'local' })

  vim.keymap.set('n', '<leader>r?', function()
    spectre.toggle()
  end, { desc = 'global' })

  vim.keymap.set('n', '<leader>rw', function()
    spectre.open_visual { select_word = true }
  end, { desc = 'global_word' })

  vim.keymap.set('v', '<leader>rw', function()
    spectre.open_visual()
  end, { desc = 'global_word' })
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
