-- Editor
vim.api.nvim_set_keymap("n", "<leader>s", ":w<cr>", { noremap = true, silent = true, desc = "save" })
vim.api.nvim_set_keymap("n", "<leader>x", ":q<cr>", { noremap = true, silent = true, desc = "close" })
-- vim.api.nvim_set_keymap("n", "<leader>;;", ":", { noremap = true, silent = true, desc = "vim cmd" })

-- Split
vim.api.nvim_set_keymap("n", "<leader>zv", "<cmd>vs<cr>", { noremap = true, silent = true, desc = "Visual.vertical_split" })
vim.api.nvim_set_keymap("n", "<leader>zs", "<cmd>sp<cr>", { noremap = true, silent = true, desc = "Visual.horizontal_split" })

-- Netrw
vim.keymap.set("n", "<leader>ef", vim.cmd.Ex, { desc = "Explorer.netrw" })

-- Resize vertically with Ctrl-Right and Ctrl-Left
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<cr>", { silent = true, desc = "vertical_resize_right" })
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<cr>", { silent = true, desc = "vertical_resize_left" })

-- Resize horizontally with Ctrl-Up and Ctrl-Down
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize -2<cr>", { silent = true, desc = "vertical_resize_up" })
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize +2<cr>", { silent = true, desc = "horizontal_resize_down" })

-- Exit terminal mode with Esc
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "exit_terminal" })

-- Buffers
vim.api.nvim_set_keymap("n", "<leader>b", ":buffers<cr>:buffer<Space>", { silent = true, desc = "go_to_buffer" })
