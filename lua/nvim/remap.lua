vim.api.nvim_set_keymap('n', '<leader>s', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>x', ':q<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>;;', ':', {noremap = true, silent = true})

-- Netrw
vim.keymap.set("n", "<leader>en", vim.cmd.Ex)

-- Resize vertically with Ctrl-Right and Ctrl-Left
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })

-- Resize horizontally with Ctrl-Up and Ctrl-Down
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize +2<CR>", { silent = true })

-- Exit terminal mode with Esc
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true, silent = true})
