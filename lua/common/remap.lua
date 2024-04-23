-- Toggle relative line numbers
vim.api.nvim_set_keymap("n", "<leader>zl", ":set relativenumber!<CR>", { desc = "toggle relative numbers" })

-- Clear highlighted search
vim.api.nvim_set_keymap("n", "<leader>z/", ":nohlsearch<CR>", { desc = "clear highlighted search" })
