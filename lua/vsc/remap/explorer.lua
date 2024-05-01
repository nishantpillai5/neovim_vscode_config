-- Neotree
vim.api.nvim_set_keymap(
  "n",
  "<leader>ee",
  ":lua require('vscode-neovim').call('workbench.view.explorer')<CR>",
  { noremap = true, silent = true }
)

-- Netrw
vim.api.nvim_set_keymap(
  "n",
  "<leader>ef",
  ":lua require('vscode-neovim').call('workbench.view.explorer')<CR>",
  { noremap = true, silent = true }
)

-- Oil

-- Vista
vim.api.nvim_set_keymap(
  "n",
  "<leader>eo",
  ":lua require('vscode-neovim').call('outline.focus')<CR>",
  { noremap = true, silent = true }
)
