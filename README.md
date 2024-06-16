# Neovim VSCode config

This repository contains my Neovim configuration, including parallel settings for the [Neovim Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim). I've aimed to keep the experience as consistent as possible across both platforms, prioritizing Neovim keybinds and bringing them to VSCode, rather than the other way around.

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

- Use the json files from `vscode_config` to configure VSCode settings
- Install following extensions:
  - [Todo Tree (gruntfuggly.todo-tree)](https://marketplace.visualstudio.com/items?itemName=gruntfuggly.todo-tree)
  - [fuzzy-search (jacobdufault.fuzzy-search)](https://marketplace.visualstudio.com/items?itemName=jacobdufault.fuzzy-search)
  - [GitLens (eamodio.gitlens)](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
  - [Whichkey (vspacecode.whichkey)](https://marketplace.visualstudio.com/items?itemName=vspacecode.whichkey)

## Todo

### Current

- lsp virtual text comes back after insert mode
- gitlinker router azure dev, open commit, open PR
- add vsc whichkey config json and complete key descriptions
- open task side bar when a task is ran
- ^M line endings with trouble preview
- don't load python dap at BufEnter, load it when needed
- fugitive git blame buffer print useful info
- edit neotree git mappings, use fugitive mappings
- cmp doesn't update with new suggestions
- toggling toggle-term doesn't work when terminal is exited
- set minimum cols for dap views
- debug config duplicates
- python lsp gotodefinition stops working sometimes
- cyclic trouble next/prev
- sidepanels (Overseer,Neotree) messes up lualine for horizontal splits (could be tmux nav plugin)
- disable notifications for noice notify

### Backlog

- Overseer
  - start a custom terminal for builds with ft set to log and autoscroll off
  - termimals with process exited don't toggle
  - lualine, show branch and commit of running build
  - Custom problem matcher
- Nvim doesn't exit properly
  - searching in git log fails because not disposing running gdb server properly, 
  - could also be because of plotposition doesn't support keyboard interrupts
- cppcheck linting
- Leetcode: run file in terminal
- Save harpoon menu on save workspace
- loading a saved session from dashboard breaks colors
- MRU in dashboard in a non git directory, changes cwd
- Path display not reversed on git files [see GH issue](https://github.com/nvim-telescope/telescope.nvim/issues/3106)
- gd prefers buffer over lsp
