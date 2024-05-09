local map = require("vsc.vscode_mapper").map

-- Terminal
map("n", "<leader>;;", "workbench.action.terminal.toggleTerminal")
map("n", "<leader>f;", "workbench.action.terminal.toggleTerminal")

-- Panel
map("n", "<leader>tq", "workbench.action.quickfix")
map("n", "<leader>tt", "workbench.action.view.problems")
map("n", "<leader>tw", "workbench.action.view.problems")
map("n", "<leader>td", "workbench.action.view.problems")
map("n", "]d", "editor.action.marker.prev")
map("n", "[d", "editor.action.marker.next")

-- Build
map("n", "<leader>oo", "workbench.action.tasks.build")
