local map = require('vsc.vscode_mapper').map

-- Telescope
map('n', '<leader>:', 'workbench.action.showCommands')
map('n', '<leader>ff', 'workbench.action.quickOpen')
map('n', '<leader>fa', 'workbench.action.quickOpen')

map('n', '<leader>fgs', 'gitlens.gitCommands.status')
map('n', '<leader>fgb', 'git.checkout')
map('n', '<leader>fgc', 'gitlens.showCommitSearch')
map('n', '<leader>fgz', 'gitlens.gitCommands.stash.list')

map('n', '<leader>fl', 'workbench.action.findInFiles')
map('n', '<leader>fL', 'workbench.action.findInFiles')
map('n', '<leader>f/', 'fuzzySearch.activeTextEditor')
map('n', '<leader>f?', 'workbench.action.findInFiles')

map('n', '<leader>fs', 'workbench.action.gotoSymbol')
map('n', '<leader>fh', 'workbench.action.showAllEditors')

-- Harpoon
map('n', '<leader>h', 'workbench.action.showAllEditors')

-- Spectre
map('n', '<leader>//', 'search.action.replaceAllInFile')
map('n', '<leader>/?', 'workbench.action.replaceInFiles')
