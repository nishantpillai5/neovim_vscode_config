local map = require("vsc.vscode_mapper").map

--Fugitive
map("n", "<leader>gs", "workbench.view.scm")
map("n", "<leader>gl", "git.viewHistory")

-- map("n", "<leader>gb", "gitlens.showQuickCommitFileDetails")
map("n", "<leader>gB", "gitlens.toggleFileBlame")
-- Visual
map("n", "<leader>zgb", "gitlens.toggleLineBlame")

-- Gitsigns
map("n", "[c", "workbench.action.editor.previousChange")
map("n", "]c", "workbench.action.editor.nextChange")

--LazyGit
