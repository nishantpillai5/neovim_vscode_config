-- Toggle relative line numbers
vim.api.nvim_set_keymap("n", "<leader>vl", ":set relativenumber!<CR>", { noremap = true, silent = true })

-- Clear highlighted search
vim.api.nvim_set_keymap("n", "<leader>vh", ":nohlsearch<CR>", { noremap = true, silent = true })