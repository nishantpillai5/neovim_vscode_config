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

- Obsidian
- Leetcode

- Keep lualine on zen mode, or replace with noneckpain
- Create installation guide and dependencies
- Nvim doesnt exit properly, searching in git log fails, not disposing running gdb server
- non git dirs break telescope file search if a file is opened
- use trouble keybinds for quickfix
- harpoon not adding relative file path
- searching from telescope in dashboard breaks colors (because lsp is loaded after file is opened?)
- loading session does the same as above
- cppcheck
- reorder overseer actions
- add title for overseer, vista
- toggle dap virtual text (blocked see issue)
- start a custom terminal for builds with ft set to log and autoscroll off
