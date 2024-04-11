if vim.g.vscode then
    require('common')
    require('vsc')
else
    require('common')
    require('nvim')
end