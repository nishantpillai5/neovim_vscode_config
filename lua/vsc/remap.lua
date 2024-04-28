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

-- Aesthetics
vim.api.nvim_set_keymap(
  "n",
  "<leader>znl",
  ":lua require('vscode-neovim').call('notifications.toggleList')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>znh",
  ":lua require('vscode-neovim').call('notifications.toggleList')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>znx",
  ":lua require('vscode-neovim').call('notifications.toggleDoNotDisturbMode')<CR>",
  { noremap = true, silent = true }
)

-- Git
vim.api.nvim_set_keymap(
  "n",
  "<leader>gss",
  ":lua require('vscode-neovim').call('workbench.view.scm')<CR>",
  { noremap = true, silent = true }
)

-- TODO: add move to git chunks

-- Finder
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

-- Search
vim.api.nvim_set_keymap(
  "n",
  "<leader>/",
  ":lua require('vscode-neovim').call('workbench.action.findInFiles')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>//",
  ":lua require('vscode-neovim').call('workbench.action.findInFiles')<CR>",
  { noremap = true, silent = true }
)

-- Explorer
vim.api.nvim_set_keymap(
  "n",
  "<leader>ee",
  ":lua require('vscode-neovim').call('workbench.view.explorer')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>ef",
  ":lua require('vscode-neovim').call('workbench.view.explorer')<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>eo",
  ":lua require('vscode-neovim').call('outline.focus')<CR>",
  { noremap = true, silent = true }
)

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
  "<leader>]t",
  ":lua require('vscode-neovim').call('editor.action.marker.prev')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>[t",
  ":lua require('vscode-neovim').call('editor.action.marker.next')<CR>",
  { noremap = true, silent = true }
)

-- Formatter
vim.api.nvim_set_keymap(
  "n",
  "<leader>p",
  ":lua require('vscode-neovim').call('editor.action.formatDocument')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>p",
  ":lua require('vscode-neovim').call('editor.action.formatSelection')<CR>",
  { noremap = true, silent = true }
)

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
vim.api.nvim_set_keymap(
  "n",
  "<leader>dd",
  ":lua require('vscode-neovim').call('workbench.view.debug')<CR>",
  { noremap = true, silent = true }
)

-- Refactor
vim.api.nvim_set_keymap(
  "n",
  "<leader>rn",
  ":lua require('vscode-neovim').call('editor.action.refactor')<CR>",
  { noremap = true, silent = true }
)

-- Visual
vim.api.nvim_set_keymap(
  "n",
  "<leader>zz",
  ":lua require('vscode-neovim').call('workbench.action.toggleMaximizeEditorGroup')<CR>",
  { noremap = true, silent = true }
)
-- vim.api.nvim_set_keymap('n', '<leader>vz', ':lua require(\'vscode-neovim\').call(\'workbench.action.toggleSidebarVisibility\')<CR>', {noremap = true, silent = true})

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
