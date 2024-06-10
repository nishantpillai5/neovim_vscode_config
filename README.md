# Neovim VSCode config

This repository contains my Neovim configuration, including parallel settings for the [Neovim Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim). I've aimed to keep the experience as consistent as possible across both platforms, prioritizing Neovim keybinds and bringing them to VSCode, rather than the other way around.

## Installation

### Linux

- `sudo snap install neovim --classic`
- `sudo snap install zig --classic --beta`
- `sudo apt install fd-find ripgrep clang gcc make python3 python-is-python3 lua5.1 unzip`
- [Nodejs](https://nodejs.org/en/download/package-manager)

### Windows

- set environment variables `HOME`,`DIR_NOTES`,`DIR_NVIM`
- `choco install git zig fd ripgrep`
- `choco install nodejs-lts --version="20.13.0"`
- `python -m pip install --user --upgrade pynvim`
- [fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) dependencies
- [ctags](https://github.com/universal-ctags/ctags)
- [debugpy](https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#debugpy)
- Lua 5.1 or LuaJIT installed & available in your system's PATH

## VSCode

### Settings

`settings.json`

```jsonc
{
  // Neovim
  "vscode-neovim.compositeKeys": {
    "jk": {
      "command": "vscode-neovim.escape"
    }
  },
  "extensions.experimental.affinity": {
    "asvetliakov.vscode-neovim": 1
  }
}
```

### Extensions

- [Todo Tree (gruntfuggly.todo-tree)](https://marketplace.visualstudio.com/items?itemName=gruntfuggly.todo-tree)
- [fuzzy-search (jacobdufault.fuzzy-search)](https://marketplace.visualstudio.com/items?itemName=jacobdufault.fuzzy-search)
- [GitLens (eamodio.gitlens)](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)

## Todo

### Current

- set minimum cols for dap views
- debug config duplicates

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
