local map = require('vsc.vscode_mapper').map

-- Trouble
map('n', '<leader>tt', 'workbench.actions.view.toggleProblems')
map('n', '<leader>tw', 'workbench.actions.view.toggleProblems')
map('n', '<leader>td', 'workbench.actions.view.toggleProblems')
map('n', '<leader>tq', 'problems.action.showQuickFixes')
map('n', '<leader>k', 'editor.action.marker.prev')
map('n', '<leader>j', 'editor.action.marker.next')
map('n', 'gr', 'editor.action.goToReferences')

-- Terminal
map('n', '<leader>;;', 'workbench.action.terminal.toggleTerminal')
map('n', '<leader>;f', 'workbench.action.terminal.toggleTerminal')
map('n', '<leader>f;', 'workbench.action.terminal.toggleTerminal')

-- Build
map('n', '<leader>oo', 'workbench.action.tasks.build')
