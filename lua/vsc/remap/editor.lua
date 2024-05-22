local map = require('vsc.vscode_mapper').map

-- Comments
map('n', '[t', 'todo-tree.goToPrevious')
map('n', ']t', 'todo-tree.goToNext')

-- Tmux like navigation
map('n', '<C-h>', 'workbench.action.navigateLeft')
map('n', '<C-j>', 'workbench.action.navigateDown')
map('n', '<C-k>', 'workbench.action.navigateUp')
map('n', '<C-l>', 'workbench.action.navigateRight')

-- Refactor
map('n', '<leader>rn', 'editor.action.refactor')
map('n', '<leader>rr', 'editor.action.refactor')

-- Misc
map('n', '<leader>zz', 'workbench.action.toggleMaximizeEditorGroup')
