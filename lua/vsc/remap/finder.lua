local map = require("vsc.vscode_mapper").map

-- Telescope
-- TODO: make this search only git files
map("n", "<leader>ff", "workbench.action.quickOpen")
map("n", "<leader>fa", "workbench.action.quickOpen")
map("n", "<leader>fg", "fuzzySearch.activeTextEditor")
map("n", "<leader>fgg", "workbench.action.findInFiles")
map("n", "<leader>f/", "workbench.action.findInFiles")
map("n", "<leader>fo", "workbench.action.gotoSymbol")

-- Harpoon
map("n", "<leader>h", "workbench.action.showAllEditors")
map("n", "<leader>fh", "workbench.action.showAllEditors")

-- Spectre
map("n", "<leader>//", "workbench.action.findInFiles")
map("n", "<leader>/", "workbench.action.findInFiles")
