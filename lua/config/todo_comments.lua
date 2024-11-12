local M = {}
M.keys = {
  { ']t', desc = 'todo' },
  { '[t', desc = 'todo' },
  { ']T', desc = 'todo_last' },
  { '[T', desc = 'todo_first' },
  { '<leader>fT', desc = 'todos_all' },
  { '<leader>tT', desc = 'todos' },
}

M.keymaps = function()
  local todo = require 'todo-comments'
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', ']t', function()
    todo.jump_next { wrap = true }
  end)

  set_keymap('n', '[t', function()
    todo.jump_prev { wrap = true }
  end)

  set_keymap('n', ']T', function()
    todo.jump_next { last = true }
  end)

  set_keymap('n', '[T', function()
    todo.jump_prev { last = true }
  end)

  set_keymap('n', '<leader>fT', function()
    vim.cmd 'TodoTelescope'
  end)

  set_keymap('n', '<leader>tT', function()
    vim.cmd 'TodoTrouble'
  end)
end

M.setup = function()
  local custom = require('common.env').TODO_CUSTOM
  require('todo-comments').setup {
    keywords = { [custom] = { icon = '󰬕', color = 'info' } },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
