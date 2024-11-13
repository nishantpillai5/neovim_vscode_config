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
}

local set_keymap = require('common.utils').get_keymap_setter(keys)

-- jk as esc
set_keymap('i', 'jk', '<Esc>')

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
set_keymap('x', '<leader>P', [["+dP]])
set_keymap('x', '<leader>p', [["+p]])

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
