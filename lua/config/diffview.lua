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

local get_main_branch = function()
  if _G.main_branch then
    return _G.main_branch
  end
  return 'main'
end

local history_toggle = function()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd.DiffviewClose()
  else
    vim.cmd 'DiffviewFileHistory %'
  end
end

local file_diff = function()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd.DiffviewClose()
  else
    vim.cmd 'DiffviewOpen -- %'
  end
end

local file_diff_from_main_toggle = function()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd.DiffviewClose()
  else
    vim.cmd('DiffviewOpen origin/' .. get_main_branch() .. '...HEAD -- %')
  end
end

M.keymaps = function()
  vim.keymap.set('n', '<leader>gd', diffview_toggle, { desc = 'diff' })
  vim.keymap.set('n', '<leader>gD', history_toggle, { desc = 'file_history' })
  vim.keymap.set('n', '<leader>gf', file_diff, { desc = 'file_diff' })
  vim.keymap.set('n', '<leader>gF', file_diff_from_main_toggle, { desc = 'file_diff_from_main' })
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
