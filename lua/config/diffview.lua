local M = {}

local get_main_branch = function()
  if _G.main_branch then
    return _G.main_branch
  end

  local get_default_branch = "git rev-parse --symbolic-full-name refs/remotes/origin/HEAD | sed 's!.*/!!'"
  return vim.fn.system(get_default_branch) or 'main'
end

local diffview_toggle = function()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd.DiffviewClose()
  else
    vim.cmd.DiffviewOpen()
  end
end

local diffview_from_main = function()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd.DiffviewClose()
  else
    vim.cmd('DiffviewOpen origin/' .. get_main_branch() .. '...HEAD')
  end
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
  vim.keymap.set('n', '<leader>gD', diffview_from_main, { desc = 'diff_from_main' })
  vim.keymap.set('n', '<leader>gH', history_toggle, { desc = 'history' })
  vim.keymap.set('n', '<leader>gf', file_diff, { desc = 'file_diff' })
  vim.keymap.set('n', '<leader>gF', file_diff_from_main_toggle, { desc = 'file_diff_from_main' })
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
