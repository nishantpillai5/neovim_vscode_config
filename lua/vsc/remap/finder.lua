-- Telescope
-- TODO: make this search only git files
vim.api.nvim_set_keymap(
  "n",
  "<leader>ff",
  ":lua require('vscode-neovim').call('workbench.action.quickOpen')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>fa",
  ":lua require('vscode-neovim').call('workbench.action.quickOpen')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>fg",
  ":lua require('vscode-neovim').call('fuzzySearch.activeTextEditor')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>fgg",
  ":lua require('vscode-neovim').call('workbench.action.findInFiles')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>f/",
  ":lua require('vscode-neovim').call('workbench.action.findInFiles')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>fo",
  ":lua require('vscode-neovim').call('workbench.action.gotoSymbol')<CR>",
  { noremap = true, silent = true }
)

-- Harpoon
vim.api.nvim_set_keymap(
  "n",
  "<leader>h",
  ":lua require('vscode-neovim').call('workbench.action.showAllEditors')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fh",
  ":lua require('vscode-neovim').call('workbench.action.showAllEditors')<CR>",
  { noremap = true, silent = true }
)

-- Spectre
vim.api.nvim_set_keymap(
  "n",
  "<leader>//",
  ":lua require('vscode-neovim').call('workbench.action.findInFiles')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>/",
  ":lua require('vscode-neovim').call('workbench.action.findInFiles')<CR>",
  { noremap = true, silent = true }
)
