-- Toggle relative line numbers
vim.keymap.set("n", "<leader>zr", ":set relativenumber!<CR>", { desc = "Visual.relative_numbers_toggle" })

-- Clear highlighted search
vim.keymap.set("n", "<leader>z/", ":nohlsearch<CR>", { desc = "Visual.clear_highlighted_search" })

-- Move line above/below
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "move_line_down" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "move_line_up" })

-- Page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "page_down" })
vim.keymap.set("n", "<C-u", "<C-u>zz", { silent = true, desc = "page_up" })

-- Next/Prev
vim.keymap.set("n", "#", "#zz", { silent = true, desc = "prev" })
vim.keymap.set("n", "*", "*zz", { silent = true, desc = "next" })

-- Yank
-- vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste" })

-- Line wrap
vim.keymap.set("n", "<leader>zw", ":set wrap!<CR>", { desc = "Visual.wrap_toggle" })
