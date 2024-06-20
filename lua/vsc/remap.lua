local vscode = require('vscode')

-------------------------------------- Helpers ------------------------------------------

local function map_action(mode, key, input, opts)
  -- Asynchronous keymaps
  vim.keymap.set(mode, key,
    function()
      vscode.action(input, opts)
    end,
    { noremap = true, silent = true }
  )
end

local function map_call(mode, key, input, opts)
  -- Synchronous keymaps
  vim.keymap.set(mode, key,
    function()
      vscode.call(input, opts)
    end,
    { noremap = true, silent = true }
  )
end

-------------------------------------- Basics -------------------------------------------

map_call('n', '<leader>x', 'workbench.action.closeActiveEditor')
map_action('n', '<leader>s', 'workbench.action.files.save')
map_call('n', '<leader>zv', 'workbench.action.splitEditorRight')
map_call('n', '<leader>zs', 'workbench.action.splitEditorDown')
map_call('n', '<leader>H', 'workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup')

-- Netrw
map_call('n', '<leader>ef', 'workbench.view.explorer')

-- Resize horizontally with Ctrl-Up and Ctrl-Down
map_call('n', '<C-Up>', 'workbench.action.increaseViewHeight')
map_call('n', '<C-Down>', 'workbench.action.decreaseViewHeight')

-- Resize vertically with Ctrl-Right and Ctrl-Left
map_call('n', '<C-Left>', 'workbench.action.decreaseViewWidth')
map_call('n', '<C-Right>', 'workbench.action.increaseViewWidth')

-------------------------------------- Aesthetics ---------------------------------------

map_call('n', '<leader>zn', 'notifications.toggleDoNotDisturbMode')

-------------------------------------- AI -----------------------------------------------

map_call('n', '<leader>cc', 'inlineChat.start')

map_call('n', '<leader>ce', 'github.copilot.interactiveEditor.explain.palette')
map_call('v', '<leader>ce', 'github.copilot.interactiveEditor.explain.palette')

map_call('n', '<leader>cf', 'github.copilot.interactiveEditor.fix')
map_call('v', '<leader>cf', 'github.copilot.interactiveEditor.fix')

-------------------------------------- Debug --------------------------------------------

-- Dap
-- map( "n", "<leader>dr", 'workbench.action.debug.run')
-- map( "n", "<leader>ds", 'workbench.action.debug.start')
map_call('n', '<F5>', 'workbench.action.debug.continue')
map_call('n', '<C-F5>', 'workbench.action.debug.stop')
map_call('n', '<F6>', 'workbench.action.debug.pause')
map_call('n', '<F7>', 'workbench.action.debug.stepInto')
map_call('n', '<C-F7>', 'workbench.action.debug.stepOut')
map_call('n', '<F8>', 'workbench.action.debug.stepOver')
map_call('n', '<leader>bb', 'editor.debug.action.toggleBreakpoint')
map_call('n', '[b', 'editor.debug.action.goToPreviousBreakpoint')
map_call('n', ']b', 'editor.debug.action.goToNextBreakpoint')

-- DAP UI
-- TODO: add hover
map_call('n', '<leader>bt', 'workbench.view.debug')

-------------------------------------- Editor -------------------------------------------

-- Comments
map_call('n', '[t', 'todo-tree.goToPrevious')
map_call('n', ']t', 'todo-tree.goToNext')

-- Tmux like navigation
map_call('n', '<C-h>', 'workbench.action.navigateLeft')
map_call('n', '<C-j>', 'workbench.action.navigateDown')
map_call('n', '<C-k>', 'workbench.action.navigateUp')
map_call('n', '<C-l>', 'workbench.action.navigateRight')

-- Undotree
map_call('n', '<leader>u', 'timeline.toggleExcludeSource:timeline.localHistory')

-- Zen
map_call('n', '<leader>zz', 'workbench.action.toggleMaximizeEditorGroup')

-------------------------------------- Explorer -----------------------------------------

map_call('n', '<leader>ee', 'workbench.view.explorer')
map_call('n', '<leader>et', 'workbench.action.toggleSidebarVisibility')

-- Vista
map_call('n', '<leader>es', 'outline.focus')

-------------------------------------- Finder -------------------------------------------

-- Telescope
map_call('n', '<leader>:', 'workbench.action.showCommands')
map_call('v', '<leader>:', 'workbench.action.showCommands')
map_call('n', '<leader>ff', 'workbench.action.quickOpen')
map_call('n', '<leader>fa', 'workbench.action.quickOpen')
map_call('n', '<leader>fA', 'workbench.action.quickOpen')

map_call('n', '<leader>fgs', 'gitlens.gitCommands.status')
map_call('n', '<leader>fgb', 'git.checkout')
map_call('n', '<leader>fgc', 'gitlens.showCommitSearch')
map_call('n', '<leader>fgz', 'gitlens.gitCommands.stash.list')

map_call('n', '<leader>fl', 'workbench.action.findInFiles')
map_call('n', '<leader>fL', 'workbench.action.findInFiles')
map_call('n', '<leader>/', 'fuzzySearch.activeTextEditor')
map_call('n', '<leader>?', 'workbench.action.findInFiles')

map_call('n', '<leader>fs', 'workbench.action.gotoSymbol')
map_call('n', '<leader>fr', 'workbench.action.openRecent')
map_call('n', '<leader>fh', 'workbench.action.showAllEditors')

-- Harpoon
map_call('n', '<leader>h', 'workbench.action.showAllEditors')

-------------------------------------- Git ----------------------------------------------

--Fugitive
map_call('n', '<leader>gs', 'workbench.view.scm')
map_call('n', '<leader>gl', 'git.viewHistory')
-- map("n", "<leader>gb", "gitlens.showQuickCommitFileDetails")
map_call('n', '<leader>gB', 'gitlens.toggleFileBlame')

--LazyGit

-- Diffview
map_call('n', '<leader>gd', 'workbench.view.scm')
map_call('n', '<leader>gD', 'git.viewFileHistory')

-- Gitlinker
map_call('n', '<leader>goc', 'gitlens.openCommitOnRemote')
map_call('n', '<leader>gop', 'gitlens.openAssociatedPullRequestOnRemote')

-- Gitsigns
map_call('n', '[c', 'workbench.action.editor.previousChange')
map_call('n', ']c', 'workbench.action.editor.nextChange')
map_call('n', '<leader>zgb', 'gitlens.toggleLineBlame')

-- Hunk maps

-------------------------------------- LSP ----------------------------------------------

-- LSP
map_call('n', 'gd', 'editor.action.revealDefinition')
map_call('n', 'gD', 'editor.action.goToDeclaration')
map_call('n', 'gi', 'editor.action.goToImplementation')
map_call('n', 'gl', 'workbench.actions.view.problems')
map_call('n', 'go', 'editor.action.goToTypeDefinition')
map_call('n', '<F2>', 'editor.action.rename')
map_call('n', '<F3>', 'editor.action.formatDocument')
map_call('n', '<F4>', 'editor.action.quickFix')

-- Formatter
map_action('n', '<leader>ls', 'editor.action.formatDocument')
map_action('v', '<leader>ls', 'editor.action.formatSelection')

-- Trouble
map_call('n', '<leader>tt', 'workbench.action.togglePanel')
map_call('n', '<leader>td', 'workbench.actions.view.toggleProblems')
map_call('n', '<leader>tq', 'problems.action.showQuickFixes')
map_call('n', '<leader>k', 'editor.action.marker.prev')
map_call('n', '<leader>j', 'editor.action.marker.next')
map_call('n', 'gr', 'editor.action.goToReferences')

-------------------------------------- Refactor -----------------------------------------

map_call('n', '<leader>rn', 'editor.action.refactor')
map_call('n', '<leader>rr', 'editor.action.refactor')

-- Spectre
map_call('n', '<leader>r/', 'search.action.replaceAllInFile')
map_call('n', '<leader>r?', 'workbench.action.replaceInFiles')

-------------------------------------- Terminal -----------------------------------------

-- Terminal
map_call('n', '<leader>;;', 'workbench.action.terminal.toggleTerminal')
map_call('n', '<leader>;f', 'workbench.action.terminal.toggleTerminal')
map_call('n', '<leader>f;', 'workbench.action.terminal.toggleTerminal')

-- Build
map_call('n', '<leader>oo', 'workbench.action.tasks.build')

-------------------------------------- Workspace ----------------------------------------

map_call('n', '<leader>ww', _G.workspace_select_cmd)
map_call('n', '<leader>wx', _G.workspace_close_cmd)

-------------------------------------- Whichkey -----------------------------------------

map_call('n', '<leader>', 'whichkey.show')

local function map_whichkey_node(mode, key, node)
  vim.keymap.set(mode, key, function()
    vscode.call("whichkey.show")
    vscode.call("whichkey.triggerKey", { args = { node } })
  end, { noremap = true, silent = true })
end

Map_whichkey_nodes = function (mode, prefix, parent_key, maps)
  if type(maps) == "string" then
    map_whichkey_node(mode, prefix, parent_key)
  else
    for key, lookup in pairs(maps) do
      if key ~= "name" then
        map_whichkey_node(mode, prefix .. key, key)
        Map_whichkey_nodes(mode, prefix .. key, key, lookup)
      end
    end
  end
end

local leader_maps = require("common.whichkey_config").leader_maps
Map_whichkey_nodes('n', '<leader>', nil, leader_maps)
