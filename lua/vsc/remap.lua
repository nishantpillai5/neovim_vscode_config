local vscode = require 'vscode'

-------------------------------------- Helpers ------------------------------------------

local function map_action(mode, key, input, opts)
  -- Asynchronous keymaps
  vim.keymap.set(mode, key, function()
    vscode.action(input, opts)
  end, { noremap = true, silent = true })
end

-------------------------------------- Basics -------------------------------------------

map_action('n', '<leader>x', 'workbench.action.closeActiveEditor')
map_action('n', '<leader>s', 'workbench.action.files.save')
map_action('n', '<leader>zv', 'workbench.action.splitEditorRight')
map_action('n', '<leader>zs', 'workbench.action.splitEditorDown')
map_action('n', '<leader>H', 'workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup')

-- Netrw
map_action('n', '<leader>ef', 'workbench.view.explorer')

-- Resize horizontally with Ctrl-Up and Ctrl-Down
map_action('n', '<C-Up>', 'workbench.action.increaseViewHeight')
map_action('n', '<C-Down>', 'workbench.action.decreaseViewHeight')

-- Resize vertically with Ctrl-Right and Ctrl-Left
map_action('n', '<C-Left>', 'workbench.action.decreaseViewWidth')
map_action('n', '<C-Right>', 'workbench.action.increaseViewWidth')

-------------------------------------- Aesthetics ---------------------------------------

map_action('n', '<leader>zn', 'notifications.toggleDoNotDisturbMode')

-------------------------------------- AI -----------------------------------------------

map_action('n', '<leader>cc', 'inlineChat.start')

map_action('n', '<leader>ce', 'github.copilot.interactiveEditor.explain.palette')
map_action('v', '<leader>ce', 'github.copilot.interactiveEditor.explain.palette')

map_action('n', '<leader>cf', 'github.copilot.interactiveEditor.fix')
map_action('v', '<leader>cf', 'github.copilot.interactiveEditor.fix')

-------------------------------------- Debug --------------------------------------------

-- Dap
-- map( "n", "<leader>dr", 'workbench.action.debug.run')
-- map( "n", "<leader>ds", 'workbench.action.debug.start')
map_action('n', '<F5>', 'workbench.action.debug.continue')
map_action('n', '<C-F5>', 'workbench.action.debug.stop')
map_action('n', '<F6>', 'workbench.action.debug.pause')
map_action('n', '<F7>', 'workbench.action.debug.stepInto')
map_action('n', '<C-F7>', 'workbench.action.debug.stepOut')
map_action('n', '<F8>', 'workbench.action.debug.stepOver')
map_action('n', '<leader>bb', 'editor.debug.action.toggleBreakpoint')
map_action('n', '[b', 'editor.debug.action.goToPreviousBreakpoint')
map_action('n', ']b', 'editor.debug.action.goToNextBreakpoint')

-- DAP UI
-- TODO: add hover
map_action('n', '<leader>bt', 'workbench.view.debug')

-------------------------------------- Editor -------------------------------------------

-- Comments
map_action('n', '[t', 'todo-tree.goToPrevious')
map_action('n', ']t', 'todo-tree.goToNext')

-- Tmux like navigation
map_action('n', '<C-h>', 'workbench.action.navigateLeft')
map_action('n', '<C-j>', 'workbench.action.navigateDown')
map_action('n', '<C-k>', 'workbench.action.navigateUp')
map_action('n', '<C-l>', 'workbench.action.navigateRight')

-- Undotree
map_action('n', '<leader>u', 'timeline.toggleExcludeSource:timeline.localHistory')

-- Zen
map_action('n', '<leader>zz', 'workbench.action.toggleMaximizeEditorGroup')

-------------------------------------- Explorer -----------------------------------------

map_action('n', '<leader>ed', 'workbench.files.action.compareFileWith')
map_action('n', '<leader>ee', 'workbench.view.explorer')
map_action('n', '<leader>eg', 'workbench.view.scm')
map_action('n', '<leader>es', 'outline.focus')
map_action('n', '<leader>ex', 'workbench.action.toggleSidebarVisibility')
map_action('n', '<leader>eyy', 'copyFilePath')
map_action('n', '<leader>eyY', 'copyRelativeFilePath')

-------------------------------------- Finder -------------------------------------------

-- Telescope
map_action('n', '<leader>:', 'workbench.action.showCommands')
map_action('v', '<leader>:', 'workbench.action.showCommands')
map_action('n', '<leader>ff', 'workbench.action.quickOpen')
map_action('n', '<leader>fa', 'workbench.action.quickOpen')
map_action('n', '<leader>fA', 'workbench.action.quickOpen')

map_action('n', '<leader>fgd', 'gitlens.openChangedFiles')
map_action('n', '<leader>fgb', 'git.checkout')
map_action('n', '<leader>fgc', 'gitlens.showCommitSearch')
map_action('n', '<leader>fgz', 'gitlens.gitCommands.stash.list')

map_action('n', '<leader>fl', 'workbench.action.findInFiles')
map_action('n', '<leader>fL', 'workbench.action.findInFiles')
map_action('n', '<leader>/', 'fuzzySearch.activeTextEditor')
map_action('n', '<leader>?', 'workbench.action.findInFiles')

map_action('n', '<leader>fs', 'workbench.action.gotoSymbol')
map_action('n', '<leader>fr', 'workbench.action.openRecent')
map_action('n', '<leader>fh', 'workbench.action.showAllEditors')

-- Grapple
map_action('n', '<leader>h', 'workbench.action.showAllEditors')

-------------------------------------- Git ----------------------------------------------

--Fugitive
map_action('n', '<leader>gs', 'workbench.view.scm')
map_action('n', '<leader>gl', 'git.viewHistory')
-- map("n", "<leader>gb", "gitlens.showQuickCommitFileDetails")
map_action('n', '<leader>gB', 'gitlens.toggleFileBlame')

--LazyGit

-- Diffview
map_action('n', '<leader>gd', 'workbench.view.scm')
map_action('n', '<leader>gD', 'git.viewFileHistory')

-- Gitlinker
map_action('n', '<leader>goc', 'gitlens.openCommitOnRemote')
map_action('n', '<leader>gop', 'gitlens.openAssociatedPullRequestOnRemote')

-- Gitsigns
map_action('n', '[c', 'workbench.action.editor.previousChange')
map_action('n', ']c', 'workbench.action.editor.nextChange')
map_action('n', '<leader>gv', 'gitlens.toggleLineBlame')

-- Hunk maps

-------------------------------------- LSP ----------------------------------------------

-- LSP
map_action('n', 'gd', 'editor.action.revealDefinition')
map_action('n', 'gD', 'editor.action.goToDeclaration')
map_action('n', 'gi', 'editor.action.goToImplementation')
map_action('n', 'gl', 'workbench.actions.view.problems')
map_action('n', 'go', 'editor.action.goToTypeDefinition')
map_action('n', '<F2>', 'editor.action.rename')
map_action('n', '<F3>', 'editor.action.formatDocument')
map_action('n', '<F4>', 'editor.action.quickFix')

-- Formatter
map_action('n', '<leader>ls', 'editor.action.formatDocument')
map_action('v', '<leader>ls', 'editor.action.formatSelection')

-- Trouble
map_action('n', '<leader>tt', 'workbench.action.togglePanel')
map_action('n', '<leader>td', 'workbench.actions.view.toggleProblems')
map_action('n', '<leader>tq', 'problems.action.showQuickFixes')
map_action('n', '<leader>k', 'editor.action.marker.prev')
map_action('n', '<leader>j', 'editor.action.marker.next')
map_action('n', 'gr', 'editor.action.goToReferences')

-------------------------------------- Refactor -----------------------------------------

map_action('n', '<leader>rn', 'editor.action.refactor')
map_action('n', '<leader>rr', 'editor.action.refactor')

-- Spectre
map_action('n', '<leader>r/', 'search.action.replaceAllInFile')
map_action('n', '<leader>r?', 'workbench.action.replaceInFiles')

-------------------------------------- Terminal -----------------------------------------

-- Terminal
map_action('n', '<leader>;;', 'workbench.action.terminal.toggleTerminal')
map_action('n', '<leader>;f', 'workbench.action.terminal.toggleTerminal')
map_action('n', '<leader>f;', 'workbench.action.terminal.toggleTerminal')

-- Build
map_action('n', '<leader>oo', 'workbench.action.tasks.build')

-------------------------------------- Workspace ----------------------------------------

map_action('n', '<leader>ww', _G.workspace_select_cmd)
map_action('n', '<leader>wx', _G.workspace_close_cmd)

-------------------------------------- Whichkey -----------------------------------------

map_action('n', '<leader>', 'whichkey.show')

local function map_whichkey_node(mode, key, node)
  vim.keymap.set(mode, key, function()
    vscode.call 'whichkey.show'
    vscode.call('whichkey.triggerKey', { args = { node } })
  end, { noremap = true, silent = true })
end

Map_whichkey_nodes = function(mode, prefix, parent_key, maps)
  if type(maps) == 'string' then
    map_whichkey_node(mode, prefix, parent_key)
  else
    for key, lookup in pairs(maps) do
      if key ~= 'name' then
        map_whichkey_node(mode, prefix .. key, key)
        Map_whichkey_nodes(mode, prefix .. key, key, lookup)
      end
    end
  end
end

local leader_maps = require('common.whichkey_config').leader_maps
Map_whichkey_nodes('n', '<leader>', nil, leader_maps)
