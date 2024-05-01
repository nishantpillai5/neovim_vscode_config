local map = require("vsc.vscode_mapper").map

-- Comments
-- Tmux like navigation
-- Refactor
map("n", "<leader>rn", "editor.action.refactor")
map("n", "<leader>rr", "editor.action.refactor")

-- Misc
map("n", "<leader>zz", "workbench.action.toggleMaximizeEditorGroup")
