local map = require('vsc.vscode_mapper').map

-- Terminal
map('n', '<leader>;;', 'workbench.action.terminal.toggleTerminal')
map('n', '<leader>;f', 'workbench.action.terminal.toggleTerminal')
map('n', '<leader>f;', 'workbench.action.terminal.toggleTerminal')

-- Build
map('n', '<leader>oo', 'workbench.action.tasks.build')
