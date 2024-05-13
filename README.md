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

- make Overseer action and dap list show in telescope instead of notify

- Update vsc keymaps

- Change cwd from dashboard
- Global marks (bookmarks)
- Learn folds

- Default to all files when not in a git repo
- non git dirs breaks telescope file search if a file is opened, searches file in file's folder instead of cwd
- add title for overseer, vista

- harpoon not adding relative file path, could be because of symlinks
- loading a saved session breaks colors (because lsp is loaded after file is opened?)
  - searching from telescope in dashboard also breaks colors

- cppcheck linting

- use trouble keybinds for quickfix
- Overseer
  - Nvim doesn't exit properly, searching in git log fails because not disposing running gdb server properly
  - start a custom terminal for builds with ft set to log and autoscroll off
  - termimals with process exited don't toggle
  - lualine, show branch and commit of running build

- Leetcode
  - run file in terminal
- Keep tabline on zen mode, or replace with noneckpain
- Lazy load 
  - lualine extensions (overseer)

- toggle dap virtual text [see GH issue](https://github.com/theHamsta/nvim-dap-virtual-text/issues/74)
