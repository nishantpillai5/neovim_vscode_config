-- Comments
-- Tmux like navigation
-- Refactor
vim.api.nvim_set_keymap(
  "n",
  "<leader>rn",
  ":lua require('vscode-neovim').call('editor.action.refactor')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>rr",
  ":lua require('vscode-neovim').call('editor.action.refactor')<CR>",
  { noremap = true, silent = true }
)

-- Misc
vim.api.nvim_set_keymap(
  "n",
  "<leader>zz",
  ":lua require('vscode-neovim').call('workbench.action.toggleMaximizeEditorGroup')<CR>",
  { noremap = true, silent = true }
)
