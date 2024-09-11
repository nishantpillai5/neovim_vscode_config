local M = {}

M.keys = {
  { '<leader>gd', desc = 'diff' },
  { '<leader>gD', desc = 'diff_from_main' },
  { '<leader>gH', desc = 'history' },
  { '<leader>gf', desc = 'file_diff' },
  { '<leader>gF', desc = 'file_diff_from_main' },
}

M.cmd = {
  'DiffviewOpen',
  'DiffviewFileHistory',
}

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
    vim.cmd('DiffviewOpen origin/' .. require('common.utils').get_main_branch() .. '...HEAD')
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
    vim.cmd('DiffviewOpen origin/' .. require('common.utils').get_main_branch() .. '...HEAD -- %')
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
