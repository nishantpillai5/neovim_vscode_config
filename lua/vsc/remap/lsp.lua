-- Formatter
vim.api.nvim_set_keymap(
  "n",
  "<leader>ls",
  ":lua require('vscode-neovim').call('editor.action.formatDocument')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>ls",
  ":lua require('vscode-neovim').call('editor.action.formatSelection')<CR>",
  { noremap = true, silent = true }
)
