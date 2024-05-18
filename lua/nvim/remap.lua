-- Resize vertically with Ctrl-Right and Ctrl-Left
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<cr>", { silent = true, desc = "vertical_resize_right" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<cr>", { silent = true, desc = "vertical_resize_left" })

-- Resize horizontally with Ctrl-Up and Ctrl-Down
vim.keymap.set("n", "<C-Up>", ":resize -2<cr>", { silent = true, desc = "vertical_resize_up" })
vim.keymap.set("n", "<C-Down>", ":resize +2<cr>", { silent = true, desc = "horizontal_resize_down" })

-- Exit terminal mode with Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true, desc = "exit_terminal" })
