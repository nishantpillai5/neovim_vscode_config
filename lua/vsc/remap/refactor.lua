local map = require('vsc.vscode_mapper').map

-- Spectre
map('n', '<leader>r/', 'search.action.replaceAllInFile')
map('n', '<leader>r?', 'workbench.action.replaceInFiles')
