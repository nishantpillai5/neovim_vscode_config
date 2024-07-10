-- Toggle relative line numbers
vim.keymap.set('n', '<leader>zl', ':set relativenumber!<CR>', { desc = 'line_no_relative' })

-- Clear highlighted search
vim.keymap.set('n', '<leader>z/', ':nohlsearch<CR>', { desc = 'clear_search' })

-- Centered navigation
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true, desc = 'page_down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true, desc = 'page_up' })
vim.keymap.set('n', '#', '#zz', { silent = true, desc = 'prev' })
vim.keymap.set('n', '*', '*zz', { silent = true, desc = 'next' })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = true, desc = 'prev' })
vim.keymap.set('n', 'n', 'nzzzv', { silent = true, desc = 'next' })

-- Yank
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'yank_to_clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["+d]], { desc = 'delete_to_clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'yank_to_clipboard' })
vim.keymap.set('x', '<leader>P', [["+dP]], { desc = 'paste_from_clipboard' })
vim.keymap.set('x', '<leader>p', [["+p]], { desc = 'paste_from_clipboard' })

-- Line wrap
vim.keymap.set('n', '<leader>zw', ':set wrap!<CR>', { desc = 'wrap' })

-- Previous buffer
vim.keymap.set('n', '<leader>H', ':b#<CR>', { desc = 'buffer_prev', silent = true })

-- Netrw
vim.keymap.set('n', '<leader>ef', vim.cmd.Ex, { desc = 'netrw' })

-- Spaceless join
vim.api.nvim_set_keymap('n', 'J', 'gJ', { noremap = true, desc = 'join_next_line' })

-- Do not draw macros
vim.keymap.set('n', '<leader>zq', ':set lazyredraw!<cr>', { desc = 'lazyredraw_toggle' })
