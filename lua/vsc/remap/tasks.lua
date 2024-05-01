-- Build
vim.api.nvim_set_keymap(
  "n",
  "<leader>oo",
  ":lua require('vscode-neovim').call('workbench.action.tasks.build')<CR>",
  { noremap = true, silent = true }
)

-- DAP
-- vim.api.nvim_set_keymap(
--   "n",
--   "<leader>dr",
--   ":lua require('vscode-neovim').call('workbench.action.debug.run')<CR>",
--   { noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap(
--   "n",
--   "<leader>ds",
--   ":lua require('vscode-neovim').call('workbench.action.debug.start')<CR>",
--   { noremap = true, silent = true }
-- )
vim.api.nvim_set_keymap(
  "n",
  "<F5>",
  ":lua require('vscode-neovim').call('workbench.action.debug.continue')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-F5>",
  ":lua require('vscode-neovim').call('workbench.action.debug.stop')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<F6>",
  ":lua require('vscode-neovim').call('workbench.action.debug.pause')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<F7>",
  ":lua require('vscode-neovim').call('workbench.action.debug.stepInto')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-F7>",
  ":lua require('vscode-neovim').call('workbench.action.debug.stepOut')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<F8>",
  ":lua require('vscode-neovim').call('workbench.action.debug.stepOver')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>db",
  ":lua require('vscode-neovim').call('editor.debug.action.toggleBreakpoint')<CR>",
  { noremap = true, silent = true }
)
-- DAP UI
-- TODO: add hover
vim.api.nvim_set_keymap(
  "n",
  "<leader>dd",
  ":lua require('vscode-neovim').call('workbench.view.debug')<CR>",
  { noremap = true, silent = true }
)
