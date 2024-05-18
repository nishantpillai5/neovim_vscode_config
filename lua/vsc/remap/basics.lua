local map = require("vsc.vscode_mapper").map

-- Basics
map("n", "<leader>x", "workbench.action.closeActiveEditor")
map("n", "<leader>s", "workbench.action.files.save")
map("n", "<leader>:", "workbench.action.showCommands")
map("n", "<leader>zv", "workbench.action.splitEditorRight")
map("n", "<leader>zs", "workbench.action.splitEditorDown")

-- Resize horizontally with Ctrl-Up and Ctrl-Down
map("n", "<C-Up>", "workbench.action.increaseViewHeight")
map("n", "<C-Down>", "workbench.action.decreaseViewHeight")

-- Resize vertically with Ctrl-Right and Ctrl-Left
map("n", "<C-Left>", "workbench.action.decreaseViewWidth")
map("n", "<C-Right>", "workbench.action.increaseViewWidth")
