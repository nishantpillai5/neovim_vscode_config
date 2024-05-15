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

## Todo

### Prio1

- Git blame open url or see commit
- Update vsc keymaps
- Default to all files when not in a git repo
- Path display not reversed on git files

### Prio2

- Global marks (bookmarks)
- Learn folds

### Prio3

- add title for overseer, vista
- loading a saved session from dashboard breaks colors

- cppcheck linting

- use trouble keybinds for quickfix
- Overseer
  - Nvim doesn't exit properly, searching in git log fails because not disposing running gdb server properly
  - start a custom terminal for builds with ft set to log and autoscroll off
  - termimals with process exited don't toggle
  - lualine, show branch and commit of running build

- Leetcode
  - run file in terminal
- Lazy load 
  - lualine extensions (overseer)

- toggle dap virtual text [see GH issue](https://github.com/theHamsta/nvim-dap-virtual-text/issues/74)
- Save workspace-> save harpoon menu

- Change cwd from dashboard, maybe better alternative is [project](https://github.com/ahmedkhalf/project.nvim)
- MRU in dashboard in a not git directory, changes cwd
