local map = require("vsc.vscode_mapper").map

--Fugitive
map("n", "<leader>gs", "workbench.view.scm")
map("n", "<leader>gl", "git.viewHistory")
-- map("n", "<leader>gb", "gitlens.showQuickCommitFileDetails")
map("n", "<leader>gB", "gitlens.toggleFileBlame")

--LazyGit

-- Diffview
map("n", "<leader>gd", "")
map("n", "<leader>gf", "")

-- Gitlinker
map("n", "<leader>gy", "")
map("n", "<leader>gY", "")

-- Gitsigns
map("n", "[c", "workbench.action.editor.previousChange")
map("n", "]c", "workbench.action.editor.nextChange")
map("n", "<leader>zgb", "gitlens.toggleLineBlame")

map("n", "<leader>gD", "")

-- Hunk maps

