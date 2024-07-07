# Neovim VSCode config

This repository contains my Neovim configuration, including parallel settings for the [Neovim Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim). I've aimed to keep the experience as consistent as possible across both platforms, prioritizing Neovim keybinds and bringing them to VSCode, rather than the other way around.

Notable features:

- Use Which-key keybinds within VSCode
- Tmux-like navigation inside VSCode

## Installation

### Linux

- `sudo snap install neovim --classic`
- `sudo apt install fd-find ripgrep clang gcc make python3 python-is-python3 lua5.1 unzip`
- [Nodejs](https://nodejs.org/en/download/package-manager)

### Windows

- `choco install git fd ripgrep`
- `choco install nodejs-lts --version="20.13.0"`
- `python -m pip install --user --upgrade pynvim`
- [fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) dependencies
- [ctags](https://github.com/universal-ctags/ctags)
- [debugpy](https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#debugpy)
- Lua 5.1 or LuaJIT ( should be available in system's PATH )
- MinGW (gcc and make should be available in system's PATH)

## VSCode Configuration

To install the configuration:

- Move the json files from `vscode_config` to [VSCode settings directory](https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations)
- Install following extensions:
  - [Whichkey (vspacecode.whichkey)](https://marketplace.visualstudio.com/items?itemName=vspacecode.whichkey)
  - [fuzzy-search (jacobdufault.fuzzy-search)](https://marketplace.visualstudio.com/items?itemName=jacobdufault.fuzzy-search)
  - [GitLens (eamodio.gitlens)](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
  - [Todo Tree (gruntfuggly.todo-tree)](https://marketplace.visualstudio.com/items?itemName=gruntfuggly.todo-tree)

## Todo

- Tasks
  - custom problem matcher (PRIO)
  - write custom parser
  - overseer firewall prompt
  - open task side bar when a task is ran
  - start a custom terminal for builds with ft set to log and autoscroll off
  - lualine, show branch and commit of running build
  - nvim doesn't exit properly
    - searching in git log fails because not disposing running gdb server properly
    - could also be because of plotposition doesn't support keyboard interrupts
- Git
  - ]x to next conflict doesn't work
  - [C next change different from main
  - git blame statusline doesn't go away when not available
  - fugitive window height
  - bind to fgh to find git hunks, fgH to grep [git hunk picker](https://github.com/nvim-telescope/telescope.nvim/pull/3131)
- Tasks
  - overseer list bind bind r to restart task
  - overseer list in a dressing window
  - bind fo to find existing task buffer
  - don't auto dispose tasks
  - autofill with last task same target but different goal
- Finder
  - (PRIO) fL doesn't work with neoscopes
  - reverse find projects related to a file
  - fh for unsaved buffers
  - integrate trailblazer with telescope, grapple, recession
  - after going to a file from telescope, filename added is not normalized (PR)
  - vista keymaps, unbind s
  - file already exists warning after navigating from telescope
  - trailblazer show all marks, change highlighting
- LSP
  - remove diagnostics from trouble panel using dd
  - map ll to refresh lsp, cmp doesn't update with new suggestions
  - python lsp is too slow, might be sharing a thread with overseer
  - cyclic trouble next/prev
  - gd prefers buffer over lsp
  - cppcheck linting
  - show argument types as virtual text
- Terminal
  - toggle doesn't work when a terminal has it's process exited
  - toggle doesn't work when no terminal exists
  - panel toggle goes to vsplit
- DAP
  - set minimum cols for dap views
  - don't load python dap at BufEnter, load it when needed
  - debug config duplicates
- UI
  - disable treesitter context for markdown
  - disable notifications for noice notify
  - sidepanels (Overseer, Neotree) messes up lualine for horizontal splits (could be tmux nav plugin)
  - zP to toggle panel positions
  - loading a saved session from dashboard breaks colors
  - [tabline in zen mode](https://github.com/folke/zen-mode.nvim/issues/116)
- VSC integration
  - create commands for all bindings
  - set whichkey settings in vsc from inside lua (ISSUE)
  - alternative: map whichkey in nvim by reading 'whichkey.bindings' table from config
- Leetcode
  - run file in terminal
