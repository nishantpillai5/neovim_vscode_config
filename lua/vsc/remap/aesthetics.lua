vim.api.nvim_set_keymap(
  "n",
  "<leader>zn",
  ":lua require('vscode-neovim').call('notifications.toggleDoNotDisturbMode')<CR>",
  { noremap = true, silent = true }
)
