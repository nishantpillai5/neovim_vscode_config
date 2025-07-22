# Neovim VSCode config

This repository contains my Neovim configuration, including parallel settings for the [Neovim Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim). I've aimed to keep the experience as consistent as possible across both platforms, prioritizing Neovim keybinds and bringing them to VSCode, rather than the other way around.

Notable features:

- Use Which-key keybinds within VSCode
- Tmux-like navigation inside VSCode

Run `:checkhealth config` to see config status.

## Requirements

- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- [Python](https://www.python.org)
- [Nodejs](https://nodejs.org/en/download/package-manager)
- [Luarocks](https://luarocks.org)

run `:checkhealth` to see all requirements from other extensions

## Installation

- Create a virtual environment for neovim
  `python -m venv ~/.virtualenvs/neovim`

- Install `pynvim` in the environment
  `~/.virtualenvs/neovim/bin/python -m pip install -U pynvim`

## VSCode Configuration

To install the configuration:

- Move the json files from `vscode_config` to [VSCode settings directory](https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations)
- Extensions used:
  - [Whichkey (vspacecode.whichkey)](https://marketplace.visualstudio.com/items?itemName=vspacecode.whichkey)
  - [fuzzy-search (jacobdufault.fuzzy-search)](https://marketplace.visualstudio.com/items?itemName=jacobdufault.fuzzy-search)
  - [GitLens (eamodio.gitlens)](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
  - [Todo Tree (gruntfuggly.todo-tree)](https://marketplace.visualstudio.com/items?itemName=gruntfuggly.todo-tree)
  - [Alt8 (maksimrv.alt8)](https://marketplace.visualstudio.com/items?itemName=maksimrv.alt8)
  - [LazyGit (tompollak.lazygit-vscode)](https://marketplace.visualstudio.com/items?itemName=tompollak.lazygit-vscode)
