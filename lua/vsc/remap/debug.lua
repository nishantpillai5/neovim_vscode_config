local map = require("vsc.vscode_mapper").map

-- DAP
-- map( "n", "<leader>dr", 'workbench.action.debug.run')
-- map( "n", "<leader>ds", 'workbench.action.debug.start')
map("n", "<F5>", "workbench.action.debug.continue")
map("n", "<C-F5>", "workbench.action.debug.stop")
map("n", "<F6>", "workbench.action.debug.pause")
map("n", "<F7>", "workbench.action.debug.stepInto")
map("n", "<C-F7>", "workbench.action.debug.stepOut")
map("n", "<F8>", "workbench.action.debug.stepOver")
map("n", "<leader>db", "editor.debug.action.toggleBreakpoint")

-- DAP UI
-- TODO: add hover
map("n", "<leader>dd", "workbench.view.debug")
