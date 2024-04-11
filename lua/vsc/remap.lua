local vscode = require('vscode-neovim')

vim.api.nvim_set_keymap('n', '<leader>s', ':lua require(\'vscode-neovim\').call(\'workbench.action.files.save\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>x', ':lua require(\'vscode-neovim\').call(\'workbench.action.closeActiveEditor\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>i', ':lua require(\'vscode-neovim\').call(\'workbench.action.showCommands\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>o', ':lua require(\'vscode-neovim\').call(\'workbench.action.gotoSymbol\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>b', ':lua require(\'vscode-neovim\').call(\'workbench.action.tasks.build\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>e', ':lua require(\'vscode-neovim\').call(\'workbench.view.explorer\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>t', ':lua require(\'vscode-neovim\').call(\'workbench.action.reopenClosedEditor\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>r', ':lua require(\'vscode-neovim\').call(\'workbench.action.refactor\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>d', ':lua require(\'vscode-neovim\').call(\'workbench.view.debug\')<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>z', ':lua require(\'vscode-neovim\').call(\'workbench.action.toggleSidebarVisibility\')<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>z', ':lua require(\'vscode-neovim\').call(\'workbench.action.focusActivityBar\')<CR>', {noremap = true, silent = true})


-- Resize vertically with Ctrl-Right and Ctrl-Left
vim.api.nvim_set_keymap('n', '<C-Left>', ':lua require(\'vscode-neovim\').call(\'workbench.action.decreaseViewWidth\')<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Right>', ':lua require(\'vscode-neovim\').call(\'workbench.action.increaseViewWidth\')<CR>', {silent = true})

-- Resize horizontally with Ctrl-Up and Ctrl-Down
vim.api.nvim_set_keymap('n', '<C-Up>', ':lua require(\'vscode-neovim\').call(\'workbench.action.increaseViewHeight\')<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Down>', ':lua require(\'vscode-neovim\').call(\'workbench.action.decreaseViewHeight\')<CR>', {silent = true})

-- Harpoon
vim.api.nvim_set_keymap('n', '<leader>h', ':lua require(\'vscode-neovim\').call(\'workbench.action.showAllEditors\')<CR>', {noremap = true, silent = true})

-- Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', ':lua require(\'vscode-neovim\').call(\'workbench.action.quickOpen\')<CR>', {noremap = true, silent = true})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})