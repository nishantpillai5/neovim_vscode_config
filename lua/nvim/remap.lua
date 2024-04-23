-- Editor
vim.api.nvim_set_keymap('n', '<leader>s', ':w<cr>', { noremap = true, silent = true, desc = "save" })
vim.api.nvim_set_keymap('n', '<leader>x', ':q<cr>', { noremap = true, silent = true, desc = "close"})
vim.api.nvim_set_keymap('n', '<leader>;;', ':', { noremap = true, silent = true, desc = "vim cmd" })

-- Split
vim.api.nvim_set_keymap("n", "<leader>zs", "<cmd>vs<cr>", { noremap = true, silent = true, desc = "vertical split" })
vim.api.nvim_set_keymap("n", "<leader>zh", "<cmd>sp<cr>", { noremap = true, silent = true, desc = "horizontal split" })

-- Netrw
vim.keymap.set("n", "<leader>ef", vim.cmd.Ex, { desc = "netrw" })

-- Resize vertically with Ctrl-Right and Ctrl-Left
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<cr>", { silent = true, desc = "vertical resize right" })
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<cr>", { silent = true, desc = "vertical resize left" })

-- Resize horizontally with Ctrl-Up and Ctrl-Down
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize -2<cr>", { silent = true, desc = "vertical resize up" })
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize +2<cr>", { silent = true, desc = "horizontal resize down" })

-- Exit terminal mode with Esc
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true, silent = true, desc = "exit terminal"})
