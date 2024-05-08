-- Editor
vim.keymap.set("n", "<leader>s", ":w<cr>", { silent = true, desc = "save" })
vim.keymap.set("n", "<leader>x", ":q<cr>", { silent = true, desc = "close" })

vim.keymap.set("n", "<leader>j", ":cnext<cr>", { silent = true, desc = "next_quickfix" })
vim.keymap.set("n", "<leader>k", ":cprev<cr>", { silent = true, desc = "prev_quickfix" })

-- Split
vim.keymap.set("n", "<leader>zv", "<cmd>vs<cr>", { desc = "Visual.vertical_split" })
vim.keymap.set("n", "<leader>zs", "<cmd>sp<cr>", { desc = "Visual.horizontal_split" })

-- Netrw
vim.keymap.set("n", "<leader>ef", vim.cmd.Ex, { desc = "Explorer.netrw" })

-- Resize vertically with Ctrl-Right and Ctrl-Left
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<cr>", { silent = true, desc = "vertical_resize_right" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<cr>", { silent = true, desc = "vertical_resize_left" })

-- Resize horizontally with Ctrl-Up and Ctrl-Down
vim.keymap.set("n", "<C-Up>", ":resize -2<cr>", { silent = true, desc = "vertical_resize_up" })
vim.keymap.set("n", "<C-Down>", ":resize +2<cr>", { silent = true, desc = "horizontal_resize_down" })

-- Exit terminal mode with Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true, desc = "exit_terminal" })
