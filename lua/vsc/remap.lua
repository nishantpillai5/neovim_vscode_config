local vscode = require('vscode-neovim')

vim.api.nvim_set_keymap('n', '<leader>s', ':lua require(\'vscode-neovim\').call(\'workbench.action.files.save\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>x', ':lua require(\'vscode-neovim\').call(\'workbench.action.closeActiveEditor\')<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>xt', ':lua require(\'vscode-neovim\').call(\'workbench.action.reopenClosedEditor\')<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>;;', ':lua require(\'vscode-neovim\').call(\'workbench.action.showCommands\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>o', ':lua require(\'vscode-neovim\').call(\'workbench.action.gotoSymbol\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ee', ':lua require(\'vscode-neovim\').call(\'workbench.view.explorer\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>r', ':lua require(\'vscode-neovim\').call(\'editor.action.refactor\')<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>z', ':lua require(\'vscode-neovim\').call(\'workbench.action.focusActivityBar\')<CR>', {noremap = true, silent = true})

-- Visual
vim.api.nvim_set_keymap('n', '<leader>vz', ':lua require(\'vscode-neovim\').call(\'workbench.action.toggleSidebarVisibility\')<CR>', {noremap = true, silent = true})

-- Build
vim.api.nvim_set_keymap('n', '<leader>bb', ':lua require(\'vscode-neovim\').call(\'workbench.action.tasks.build\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>bd', ':lua require(\'vscode-neovim\').call(\'workbench.view.debug\')<CR>', {noremap = true, silent = true})

-- Run and debug
vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require(\'vscode-neovim\').call(\'workbench.action.debug.start\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>dx', ':lua require(\'vscode-neovim\').call(\'workbench.action.debug.stop\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>dr', ':lua require(\'vscode-neovim\').call(\'workbench.action.debug.run\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require(\'vscode-neovim\').call(\'workbench.action.debug.continue\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>dp', ':lua require(\'vscode-neovim\').call(\'workbench.action.debug.pause\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>db', ':lua require(\'vscode-neovim\').call(\'editor.debug.action.toggleBreakpoint\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>dj', ':lua require(\'vscode-neovim\').call(\'workbench.action.debug.stepInto\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>dk', ':lua require(\'vscode-neovim\').call(\'workbench.action.debug.stepOut\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require(\'vscode-neovim\').call(\'workbench.action.debug.stepOver\')<CR>', {noremap = true, silent = true})

-- Resize vertically with Ctrl-Right and Ctrl-Left
vim.api.nvim_set_keymap('n', '<C-Left>', ':lua require(\'vscode-neovim\').call(\'workbench.action.decreaseViewWidth\')<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Right>', ':lua require(\'vscode-neovim\').call(\'workbench.action.increaseViewWidth\')<CR>', {silent = true})

-- Resize horizontally with Ctrl-Up and Ctrl-Down
vim.api.nvim_set_keymap('n', '<C-Up>', ':lua require(\'vscode-neovim\').call(\'workbench.action.increaseViewHeight\')<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Down>', ':lua require(\'vscode-neovim\').call(\'workbench.action.decreaseViewHeight\')<CR>', {silent = true})

-- Harpoon
vim.api.nvim_set_keymap('n', '<leader>h', ':lua require(\'vscode-neovim\').call(\'workbench.action.showAllEditors\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fh', ':lua require(\'vscode-neovim\').call(\'workbench.action.showAllEditors\')<CR>', {noremap = true, silent = true})

-- Terminal
vim.api.nvim_set_keymap('n', '<leader>;t', ':lua require(\'vscode-neovim\').call(\'workbench.action.terminal.toggleTerminal\')<CR>', {noremap = true, silent = true})

-- Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', ':lua require(\'vscode-neovim\').call(\'workbench.action.quickOpen\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fg', ':lua require(\'vscode-neovim\').call(\'fuzzySearch.activeTextEditor\')<CR>', {noremap = true, silent = true})

-- Visual
vim.api.nvim_set_keymap('n', '<leader>vz', ':lua require(\'vscode-neovim\').call(\'workbench.action.toggleMaximizeEditorGroup\')<CR>', {noremap = true, silent = true})

-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
