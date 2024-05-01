local map = require("vsc.vscode_mapper").map

-- Formatter
map("n", "<leader>ls", "editor.action.formatDocument")
map("v", "<leader>ls", "editor.action.formatSelection")
