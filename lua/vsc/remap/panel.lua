-- Terminal
vim.api.nvim_set_keymap(
  "n",
  "<leader>;;",
  ":lua require('vscode-neovim').call('workbench.action.terminal.toggleTerminal')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>f;",
  ":lua require('vscode-neovim').call('workbench.action.terminal.toggleTerminal')<CR>",
  { noremap = true, silent = true }
)

-- Panel
vim.api.nvim_set_keymap(
  "n",
  "<leader>tq",
  ":lua require('vscode-neovim').call('workbench.action.quickfix')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>tt",
  ":lua require('vscode-neovim').call('workbench.action.view.problems')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>tw",
  ":lua require('vscode-neovim').call('workbench.action.view.problems')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>td",
  ":lua require('vscode-neovim').call('workbench.action.view.problems')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "]d",
  ":lua require('vscode-neovim').call('editor.action.marker.prev')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "[d",
  ":lua require('vscode-neovim').call('editor.action.marker.next')<CR>",
  { noremap = true, silent = true }
)
