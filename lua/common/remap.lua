-- Toggle relative line numbers
vim.api.nvim_set_keymap("n", "<leader>zr", ":set relativenumber!<CR>", { desc = "Visual.toggle_relative_numbers" })

-- Clear highlighted search
vim.api.nvim_set_keymap("n", "<leader>z/", ":nohlsearch<CR>", { desc = "Visual.clear_highlighted_search" })

-- Move line above/below
vim.api.nvim_set_keymap("v", "J", ":m '>+1<cr>gv=gv", { desc = "move_line_down" })
vim.api.nvim_set_keymap("v", "K", ":m '<-2<cr>gv=gv", { desc = "move_line_up" })

-- Page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "page_down" })
vim.keymap.set("n", "<C-u", "<C-u>zz", { desc = "page_up" })

-- Yank
-- vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste" })
