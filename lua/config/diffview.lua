local M = {}

local diffview_toggle = function()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd.DiffviewClose()
  else
    vim.cmd.DiffviewOpen()
  end
end

local history_toggle = function()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd.DiffviewClose()
  else
    vim.cmd.DiffviewFileHistory()
  end
end

M.keymaps = function()
  vim.keymap.set('n', '<leader>gd', diffview_toggle, { desc = 'Git.diff_global' })
  vim.keymap.set('n', '<leader>gf', history_toggle, { desc = 'Git.file_history' })
end

return M
