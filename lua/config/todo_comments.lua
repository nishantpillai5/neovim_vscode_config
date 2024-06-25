local M = {}
M.keymaps = function()
  local todo = require 'todo-comments'

  vim.keymap.set('n', ']t', function()
    todo.jump_next({ wrap = true })
  end, { desc = 'todo' })

  vim.keymap.set('n', '[t', function()
    todo.jump_prev({ wrap = true })
  end, { desc = 'todo' })

  vim.keymap.set('n', ']T', function()
    todo.jump_next({ last = true })
  end, { desc = 'todo' })

  vim.keymap.set('n', '[T', function()
    todo.jump_prev({ last = true })
  end, { desc = 'todo' })

  vim.keymap.set('n', '<leader>ft', function()
    vim.cmd 'TodoTelescope'
  end, { desc = 'todos' })

  vim.keymap.set('n', '<leader>tT', function()
    vim.cmd 'TodoTrouble'
  end, { desc = 'todos' })
end

M.setup = function()
  require('todo-comments').setup {
    keywords = { NISH = { icon = '󰬕', color = 'info' } },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
