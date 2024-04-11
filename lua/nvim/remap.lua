vim.api.nvim_set_keymap('n', '<leader>s', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>x', ':q<CR>', {noremap = true, silent = true})

-- Resize vertically with Ctrl-Right and Ctrl-Left
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })

-- Resize horizontally with Ctrl-Up and Ctrl-Down
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize +2<CR>", { silent = true })