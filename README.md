# Neovim VSCode config

This repository contains my Neovim configuration which also has parallel configuration for the [Neovim Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim). Tried to keep the experience as close as possible for both platforms. Keybinds are meant to be Neovim first, i.e. taking Neovim keybinds to VSCode rather than the other way around.

## Installation

### Windows

- set `HOME` environment variable
- `choco install git`
- `choco install nodejs-lts --version="20.13.0"`
- `choco install ripgrep`
- `choco install zig`
- `choco install fd`
- `python -m pip install --user --upgrade pynvim`
- [debugpy](https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#debugpy)
- [ctags](https://github.com/universal-ctags/ctags)

### VSCode settings

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

Extensions
- Todo tree
- fuzzy search
- gitlens

## Todo

### Current

- Add buffer unsaved exceptions for overseer buffers
- Learn folds
- Move plugin to common
  - Macro
  - Dial
  - Marks
  - Coerce

### Backlog

- add window title for overseer, vista
- cppcheck linting
- use trouble keybinds for quickfix
- Overseer
  - Nvim doesn't exit properly, searching in git log fails because not disposing running gdb server properly
  - start a custom terminal for builds with ft set to log and autoscroll off
  - termimals with process exited don't toggle
  - lualine, show branch and commit of running build
- Leetcode: run file in terminal
- toggle dap virtual text [see GH issue](https://github.com/theHamsta/nvim-dap-virtual-text/issues/74)
- Save harpoon menu on save workspace
- loading a saved session from dashboard breaks colors
- MRU in dashboard in a non git directory, changes cwd
- Path display not reversed on git files [see GH issue](https://github.com/nvim-telescope/telescope.nvim/issues/3106)
