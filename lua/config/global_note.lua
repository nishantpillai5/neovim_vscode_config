local M = {}

M.keys = {
  { '<leader>nn', desc = 'current' },
}

M.keymaps = function()
  local global_note = require 'global-note'
  vim.keymap.set('n', '<leader>nn', global_note.toggle_note, { desc = 'current' })
end

M.setup = function()
  local global_note = require 'global-note'
  local DIR_NOTES = require('common.env').DIR_NOTES
  global_note.setup {
    filename = 'current.md',
    directory = DIR_NOTES,
    title = 'NOTE',
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
