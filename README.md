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
- OpenDebugAD7.exe should be available in system's PATH

## VSCode Configuration

To install the configuration:

- Move the json files from `vscode_config` to [VSCode settings directory](https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations)
- Install following extensions:
  - [Whichkey (vspacecode.whichkey)](https://marketplace.visualstudio.com/items?itemName=vspacecode.whichkey)
  - [fuzzy-search (jacobdufault.fuzzy-search)](https://marketplace.visualstudio.com/items?itemName=jacobdufault.fuzzy-search)
  - [GitLens (eamodio.gitlens)](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
  - [Todo Tree (gruntfuggly.todo-tree)](https://marketplace.visualstudio.com/items?itemName=gruntfuggly.todo-tree)
  - [Alt8 (maksimrv.alt8)](https://marketplace.visualstudio.com/items?itemName=maksimrv.alt8)
  - [LazyGit (tompollak.lazygit-vscode)](https://marketplace.visualstudio.com/items?itemName=tompollak.lazygit-vscode)
