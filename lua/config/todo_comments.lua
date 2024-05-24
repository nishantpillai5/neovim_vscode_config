local M = {}
M.keymaps = function()
  local todo = require 'todo-comments'

  vim.keymap.set('n', ']t', function()
    todo.jump_next()
  end, { desc = 'Next.todo' })

  vim.keymap.set('n', '[t', function()
    todo.jump_prev()
  end, { desc = 'Prev.todo' })

  vim.keymap.set('n', '<leader>gc', function()
    vim.cmd("TodoTelescope")
  end, { desc = 'Git.todos' })
end

M.setup = function()
  require('todo-comments').setup {
    keywords = { NISH = { icon = '󰬕', color = 'info' } },
  }
end
return M
