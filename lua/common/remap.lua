-- Toggle relative line numbers
vim.api.nvim_set_keymap("n", "<leader>zl", ":set relativenumber!<CR>", { noremap = true, silent = true })

-- Clear highlighted search
vim.api.nvim_set_keymap("n", "<leader>zh", ":nohlsearch<CR>", { noremap = true, silent = true })
