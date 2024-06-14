local map = require('vsc.vscode_mapper').map

-- LSP
map('n', 'gd', 'editor.action.revealDefinition')
map('n', 'gD', 'editor.action.goToDeclaration')
map('n', 'gi', 'editor.action.goToImplementation')
map('n', 'gl', 'workbench.actions.view.problems')
map('n', 'go', 'editor.action.goToTypeDefinition')
map('n', '<F2>', 'editor.action.rename')
map('n', '<F3>', 'editor.action.formatDocument')
map('n', '<F4>', 'editor.action.quickFix')

-- Formatter
map('n', '<leader>ls', 'editor.action.formatDocument')
map('v', '<leader>ls', 'editor.action.formatSelection')

-- Trouble
map('n', '<leader>tt', 'workbench.actions.view.toggleProblems')
map('n', '<leader>tw', 'workbench.actions.view.toggleProblems')
map('n', '<leader>td', 'workbench.actions.view.toggleProblems')
map('n', '<leader>tq', 'problems.action.showQuickFixes')
map('n', '<leader>k', 'editor.action.marker.prev')
map('n', '<leader>j', 'editor.action.marker.next')
map('n', 'gr', 'editor.action.goToReferences')