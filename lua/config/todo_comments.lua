local M = {}
M.keymaps = function()
  local todo = require 'todo-comments'

  vim.keymap.set('n', ']t', function()
    todo.jump_next()
  end, { desc = 'todo' })

  vim.keymap.set('n', '[t', function()
    todo.jump_prev()
  end, { desc = 'todo' })

  vim.keymap.set('n', '<leader>ft', function()
    -- TODO: load telescope if not loaded
    vim.cmd 'TodoTelescope'
  end, { desc = 'todos' })

  vim.keymap.set('n', '<leader>tT', function()
    -- TODO: load trouble if not loaded
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
