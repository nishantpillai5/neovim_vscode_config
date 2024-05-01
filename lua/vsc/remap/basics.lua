local vscode = require("vscode-neovim")

-- Basics
vim.api.nvim_set_keymap(
  "n",
  "<leader>x",
  ":lua require('vscode-neovim').call('workbench.action.closeActiveEditor')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>s",
  ":lua require('vscode-neovim').call('workbench.action.files.save')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  ":",
  ":lua require('vscode-neovim').call('workbench.action.showCommands')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>zv",
  ":lua require('vscode-neovim').call('workbench.action.splitEditorRight')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>zs",
  ":lua require('vscode-neovim').call('workbench.action.splitEditorDown')<CR>",
  { noremap = true, silent = true }
)

-- Resize horizontally with Ctrl-Up and Ctrl-Down
vim.api.nvim_set_keymap(
  "n",
  "<C-Up>",
  ":lua require('vscode-neovim').call('workbench.action.increaseViewHeight')<CR>",
  { silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-Down>",
  ":lua require('vscode-neovim').call('workbench.action.decreaseViewHeight')<CR>",
  { silent = true }
)

-- Resize vertically with Ctrl-Right and Ctrl-Left
vim.api.nvim_set_keymap(
  "n",
  "<C-Left>",
  ":lua require('vscode-neovim').call('workbench.action.decreaseViewWidth')<CR>",
  { silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-Right>",
  ":lua require('vscode-neovim').call('workbench.action.increaseViewWidth')<CR>",
  { silent = true }
)
