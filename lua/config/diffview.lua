local M = {}

M.keys = {
  { '<leader>gd', desc = 'diff' },
  { '<leader>gD', desc = 'diff_from_main' },
  { '<leader>gH', desc = 'history' },
  { '<leader>gf', desc = 'file_diff' },
  { '<leader>gF', desc = 'file_diff_from_main' },
  { '<leader>gzh', desc = 'stash_file_history' },
  { '<leader>gzH', desc = 'stash_history' },
}

M.cmd = {
  'DiffviewOpen',
  'DiffviewFileHistory',
}

local close_wrapper = function(func)
  return function()
    local lib = require 'diffview.lib'
    local view = lib.get_current_view()
    if view then
      vim.cmd.DiffviewClose()
    else
      func()
    end
  end
end

local diffview_toggle = close_wrapper(function()
  vim.cmd.DiffviewOpen()
end)

local diffview_from_main = close_wrapper(function()
  vim.cmd('DiffviewOpen origin/' .. require('common.utils').get_main_branch() .. '...HEAD')
end)

local history_toggle = close_wrapper(function()
  vim.cmd 'DiffviewFileHistory %'
end)

local file_diff = close_wrapper(function()
  vim.cmd 'DiffviewOpen -- %'
end)

local file_diff_from_main_toggle = close_wrapper(function()
  vim.cmd('DiffviewOpen origin/' .. require('common.utils').get_main_branch() .. '...HEAD -- %')
end)

local stash_file_history_toggle = close_wrapper(function()
  vim.cmd 'DiffviewFileHistory % -g --range=stash'
end)

local stash_history_toggle = close_wrapper(function()
  vim.cmd 'DiffviewFileHistory -g --range=stash'
end)

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>gd', diffview_toggle)
  set_keymap('n', '<leader>gD', diffview_from_main)
  set_keymap('n', '<leader>gH', history_toggle)
  set_keymap('n', '<leader>gf', file_diff)
  set_keymap('n', '<leader>gF', file_diff_from_main_toggle)
  set_keymap('n', '<leader>gzh', stash_file_history_toggle)
  set_keymap('n', '<leader>gzH', stash_history_toggle)
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
