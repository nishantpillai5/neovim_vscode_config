local keys = {
  { 'jk', desc = 'escape' },
  { '<leader>zl', desc = 'line_no_relative' },
  { '<leader>z/', desc = 'clear_search' },
  { '<C-d>', desc = 'page_down' },
  { '<C-u>', desc = 'page_up' },
  { '#', desc = 'prev' },
  { '*', desc = 'next' },
  { 'N', desc = 'prev' },
  { 'n', desc = 'next' },
  { '<leader>y', desc = 'yank_to_clipboard' },
  { '<leader>Y', desc = 'yank_line_to_clipboard' },
  { '<leader>d', desc = 'delete_to_clipboard' },
  { '<leader>D', desc = 'delete_to_void' },
  { '<leader>P', desc = 'delete_then_paste_from_clipboard' },
  { '<leader>p', desc = 'paste_from_clipboard' },
  { '<leader>zw', desc = 'wrap' },
  { '<leader>H', desc = 'buffer_prev' },
  { '<leader>eF', desc = 'netrw' },
  { 'J', desc = 'join_next_line' },
  { '<leader>zq', desc = 'lazyredraw_toggle' },
  { 'gco', desc = 'add_comment' },
  { 'H', desc = 'beginning_of_line' },
  { 'L', desc = 'end_of_line' },
  { '<Tab>', desc = 'matching_bracket' },
  -- { 'dd', desc = 'delete_line' },
  -- { 'yc', desc = 'yank_comment' },

  { '<leader>ew', desc = 'cd_to_current_file' },
  { '<leader>we', desc = 'cd_to_current_file' },
}

local set_keymap = require('common.utils').get_keymap_setter(keys)

-- jk as esc
set_keymap('i', 'jk', '<Esc>')

-- H L as ^ and $
-- By default, H and L moves to the first visible line in the window
set_keymap({ 'n', 'o', 'v' }, 'H', '^')
set_keymap({ 'n', 'o', 'v' }, 'L', '$')

-- Tab as %
-- By default, Tab moves to the next tabstop
set_keymap({ 'n', 'o', 'v' }, '<Tab>', '%')

-- Delete line but if empty don't put it in any regiester
set_keymap('n', 'dd', function()
  if vim.api.nvim_get_current_line():match '^%s*$' then
    return '"_dd'
  end
  return 'dd'
end, { expr = true, noremap = false })

-- TODO: doesn't work
-- Duplicate a line and comment out the first line
-- vim.keymap.set({ 'n', 'o' }, 'yc', function()
--   vim.cmd 'normal! yygccp'
-- end, { expr = true, noremap = false })

-- Toggle relative line numbers
set_keymap('n', '<leader>zl', ':set relativenumber!<cr>')

-- Clear highlighted search
set_keymap('n', '<leader>z/', ':nohlsearch<cr>')

-- Centered navigation
set_keymap('n', '<C-d>', '<C-d>zz')
set_keymap('n', '<C-u>', '<C-u>zz')
set_keymap('n', '#', '#zz')
set_keymap('n', '*', '*zz')
set_keymap('n', 'N', 'Nzzzv')
set_keymap('n', 'n', 'nzzzv')

-- Yank
set_keymap({ 'n', 'v' }, '<leader>y', [["+y]])
set_keymap('n', '<leader>Y', [["+Y]])
set_keymap({ 'n', 'v' }, '<leader>d', [["+d]])
set_keymap({ 'n', 'v' }, '<leader>D', [["_d]])
set_keymap({ 'n', 'x' }, '<leader>P', [["+dP]])
set_keymap({ 'n', 'x' }, '<leader>p', [["+p]])

-- Line wrap
set_keymap('n', '<leader>zw', ':set wrap!<cr>')

-- Previous buffer
set_keymap('n', '<leader>H', ':b#<cr>')

-- Netrw
set_keymap('n', '<leader>eF', vim.cmd.Ex)

-- Spaceless join
set_keymap('n', 'J', 'gJ')

-- Do not draw macros
set_keymap('n', '<leader>zq', ':set lazyredraw!<cr>')

-- Add custom comment
set_keymap('n', 'gco', 'o' .. require('common.env').TODO_CUSTOM .. ': <esc>:normal gcc<cr>A')

-- cd to current file
local function cd_to_current_file()
  local file = vim.fn.expand '%:p'
  if file == '' then
    vim.notify('No file to cd to', vim.log.levels.WARN)
    return
  end
  local dir = vim.fn.fnamemodify(file, ':p:h')
  vim.cmd('cd ' .. dir)
  vim.notify('Changed directory to: ' .. dir)
end

set_keymap('n', '<leader>ew', cd_to_current_file)
set_keymap('n', '<leader>we', cd_to_current_file)
