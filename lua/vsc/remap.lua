-- Helper
local function map(mode, key, action)
  vim.api.nvim_set_keymap(
    mode,
    key,
    ":lua require('vscode-neovim').call('" .. action .. "')<CR>",
    { noremap = true, silent = true }
  )
end

-------------------- Basics -------------------------------

map('n', '<leader>x', 'workbench.action.closeActiveEditor')
map('n', '<leader>s', 'workbench.action.files.save')
map('n', '<leader>zv', 'workbench.action.splitEditorRight')
map('n', '<leader>zs', 'workbench.action.splitEditorDown')
map('n', '<leader>H', 'workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup')

-- Netrw
map('n', '<leader>ef', 'workbench.view.explorer')

-- Resize horizontally with Ctrl-Up and Ctrl-Down
map('n', '<C-Up>', 'workbench.action.increaseViewHeight')
map('n', '<C-Down>', 'workbench.action.decreaseViewHeight')

-- Resize vertically with Ctrl-Right and Ctrl-Left
map('n', '<C-Left>', 'workbench.action.decreaseViewWidth')
map('n', '<C-Right>', 'workbench.action.increaseViewWidth')

-------------------- Aesthetics ---------------------------

map('n', '<leader>zn', 'notifications.toggleDoNotDisturbMode')

-------------------- AI -----------------------------------

map('n', '<leader>cc', 'inlineChat.start')
map('n', '<leader>cc', 'inlineChat.start')

map('n', '<leader>ce', 'github.copilot.interactiveEditor.explain.palette')
map('v', '<leader>ce', 'github.copilot.interactiveEditor.explain.palette')

map('n', '<leader>cf', 'github.copilot.interactiveEditor.fix')
map('v', '<leader>cf', 'github.copilot.interactiveEditor.fix')

-------------------- Debug --------------------------------

-- Dap
-- map( "n", "<leader>dr", 'workbench.action.debug.run')
-- map( "n", "<leader>ds", 'workbench.action.debug.start')
map('n', '<F5>', 'workbench.action.debug.continue')
map('n', '<C-F5>', 'workbench.action.debug.stop')
map('n', '<F6>', 'workbench.action.debug.pause')
map('n', '<F7>', 'workbench.action.debug.stepInto')
map('n', '<C-F7>', 'workbench.action.debug.stepOut')
map('n', '<F8>', 'workbench.action.debug.stepOver')
map('n', '<leader>bb', 'editor.debug.action.toggleBreakpoint')
map('n', '[b', 'editor.debug.action.goToPreviousBreakpoint')
map('n', ']b', 'editor.debug.action.goToNextBreakpoint')

-- DAP UI
-- TODO: add hover
map('n', '<leader>bt', 'workbench.view.debug')

-------------------- Editor -------------------------------

-- Comments
map('n', '[t', 'todo-tree.goToPrevious')
map('n', ']t', 'todo-tree.goToNext')

-- Tmux like navigation
map('n', '<C-h>', 'workbench.action.navigateLeft')
map('n', '<C-j>', 'workbench.action.navigateDown')
map('n', '<C-k>', 'workbench.action.navigateUp')
map('n', '<C-l>', 'workbench.action.navigateRight')

-- Undotree
map('n', '<leader>u', 'timeline.toggleExcludeSource:timeline.localHistory')

-- Zen
map('n', '<leader>zz', 'workbench.action.toggleMaximizeEditorGroup')

-------------------- Explorer -----------------------------

map('n', '<leader>ee', 'workbench.view.explorer')
map('n', '<leader>et', 'workbench.view.explorer')

-- Vista
map('n', '<leader>es', 'outline.focus')

-------------------- Finder -------------------------------

-- Telescope
map('n', '<leader>:', 'workbench.action.showCommands')
map('v', '<leader>:', 'workbench.action.showCommands')
map('n', '<leader>ff', 'workbench.action.quickOpen')
map('n', '<leader>fa', 'workbench.action.quickOpen')
map('n', '<leader>fA', 'workbench.action.quickOpen')

map('n', '<leader>fgs', 'gitlens.gitCommands.status')
map('n', '<leader>fgb', 'git.checkout')
map('n', '<leader>fgc', 'gitlens.showCommitSearch')
map('n', '<leader>fgz', 'gitlens.gitCommands.stash.list')

map('n', '<leader>fl', 'workbench.action.findInFiles')
map('n', '<leader>fL', 'workbench.action.findInFiles')
map('n', '<leader>/', 'fuzzySearch.activeTextEditor')
map('n', '<leader>?', 'workbench.action.findInFiles')

map('n', '<leader>fs', 'workbench.action.gotoSymbol')
map('n', '<leader>fr', 'workbench.action.openRecent')
map('n', '<leader>fh', 'workbench.action.showAllEditors')

-- Harpoon
map('n', '<leader>h', 'workbench.action.showAllEditors')

-------------------- Git ----------------------------------

--Fugitive
map('n', '<leader>gs', 'workbench.view.scm')
map('n', '<leader>gl', 'git.viewHistory')
-- map("n", "<leader>gb", "gitlens.showQuickCommitFileDetails")
map('n', '<leader>gB', 'gitlens.toggleFileBlame')

--LazyGit

-- Diffview
map('n', '<leader>gd', 'workbench.view.scm')
map('n', '<leader>gD', 'git.viewFileHistory')

-- Gitlinker
map('n', '<leader>goc', 'gitlens.openCommitOnRemote')
map('n', '<leader>gop', 'gitlens.openAssociatedPullRequestOnRemote')

-- Gitsigns
map('n', '[c', 'workbench.action.editor.previousChange')
map('n', ']c', 'workbench.action.editor.nextChange')
map('n', '<leader>zgb', 'gitlens.toggleLineBlame')

-- Hunk maps

-------------------- LSP ----------------------------------

-- LSP
map('n', 'gd', 'editor.action.revealDefinition')
map('n', 'gD', 'editor.action.goToDeclaration')
map('n', 'gi', 'editor.action.goToImplementation')
map('n', 'gl', 'workbench.actions.view.problems')
map('n', 'go', 'editor.action.goToTypeDefinition')
map('n', '<F2>', 'editor.action.rename')
map('n', '<F3>', 'editor.action.formatDocument')
map('n', '<F4>', 'editor.action.quickFix')

-- Formatter
map('n', '<leader>ls', 'editor.action.formatDocument')
map('v', '<leader>ls', 'editor.action.formatSelection')

-- Trouble
map('n', '<leader>tt', 'workbench.actions.view.toggleProblems')
map('n', '<leader>tw', 'workbench.actions.view.toggleProblems')
map('n', '<leader>td', 'workbench.actions.view.toggleProblems')
map('n', '<leader>tq', 'problems.action.showQuickFixes')
map('n', '<leader>k', 'editor.action.marker.prev')
map('n', '<leader>j', 'editor.action.marker.next')
map('n', 'gr', 'editor.action.goToReferences')

-------------------- Refactor -----------------------------

map('n', '<leader>rn', 'editor.action.refactor')
map('n', '<leader>rr', 'editor.action.refactor')

-- Spectre
map('n', '<leader>r/', 'search.action.replaceAllInFile')
map('n', '<leader>r?', 'workbench.action.replaceInFiles')

-------------------- Terminal -----------------------------

-- Terminal
map('n', '<leader>;;', 'workbench.action.terminal.toggleTerminal')
map('n', '<leader>;f', 'workbench.action.terminal.toggleTerminal')
map('n', '<leader>f;', 'workbench.action.terminal.toggleTerminal')

-- Build
map('n', '<leader>oo', 'workbench.action.tasks.build')

-------------------- Whichkey -----------------------------

map('n', '<leader>', 'whichkey.show')
