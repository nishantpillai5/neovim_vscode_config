--Fugitive
vim.api.nvim_set_keymap(
  "n",
  "<leader>gs",
  ":lua require('vscode-neovim').call('workbench.view.scm')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>gl",
  ":lua require('vscode-neovim').call('git.viewHistory')<CR>",
  { noremap = true, silent = true }
)

--LazyGit

--Gitsigns
-- TODO: stage hunks, move to chunk
