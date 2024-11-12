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
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>gd', diffview_toggle)
  set_keymap('n', '<leader>gD', diffview_from_main)
  set_keymap('n', '<leader>gH', history_toggle)
  set_keymap('n', '<leader>gf', file_diff)
  set_keymap('n', '<leader>gF', file_diff_from_main_toggle)
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
