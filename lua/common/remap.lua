-- Toggle relative line numbers
vim.keymap.set('n', '<leader>zr', ':set relativenumber!<CR>', { desc = 'relative_numbers_toggle' })

-- Clear highlighted search
vim.keymap.set('n', '<leader>z/', ':nohlsearch<CR>', { desc = 'clear_highlighted_search' })

-- Page up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true, desc = 'page_down' })
vim.keymap.set('n', '<C-u', '<C-u>zz', { silent = true, desc = 'page_up' })

-- Next/Prev
vim.keymap.set('n', '#', '#zz', { silent = true, desc = 'prev' })
vim.keymap.set('n', '*', '*zz', { silent = true, desc = 'next' })

-- Yank
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'yank_to_clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["+d]], { desc = 'delete_to_clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'yank_to_clipboard' })
vim.keymap.set('x', '<leader>P', [["+dP]], { desc = 'paste_from_clipboard' })
vim.keymap.set('x', '<leader>p', [["+p]], { desc = 'paste_from_clipboard' })

-- Line wrap
vim.keymap.set('n', '<leader>zw', ':set wrap!<CR>', { desc = 'wrap_toggle' })

-- Previous buffer
vim.keymap.set('n', '<leader>H', ':b#<CR>', { desc = 'buffer_prev', silent = true })

-- vim.keymap.set("n", "<leader>j", ":cnext<cr>", { silent = true, desc = "next_quickfix" })
-- vim.keymap.set("n", "<leader>k", ":cprev<cr>", { silent = true, desc = "prev_quickfix" })

-- vim.keymap.set("n", "<leader>J", ":lnext<cr>", { silent = true, desc = "next_loclist" })
-- vim.keymap.set("n", "<leader>K", ":lprev<cr>", { silent = true, desc = "prev_loclist" })

-- Netrw
vim.keymap.set('n', '<leader>ef', vim.cmd.Ex, { desc = 'netrw' })

-- Spaceless join
vim.api.nvim_set_keymap('n', 'J', 'gJ', { noremap = true, desc = 'join_next_line' })

-- Do not draw macros
vim.keymap.set('n', '<leader>zq', ':set lazyredraw!<cr>', { desc = 'lazyredraw_toggle' })
