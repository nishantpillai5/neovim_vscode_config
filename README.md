# Neovim VSCode config

This repository contains my Neovim configuration which also has parallel configuration for the [Neovim Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim). Tried to keep the experience as close as possible for both platforms. Keybinds are meant to be Neovim first, i.e. taking Neovim keybinds to VSCode rather than the other way around.

## VSCode settings

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

- log lsp
- add title for overseer, vista
- reorder overseer actions
- Go to next breakpoint
- reduce default size of toggleterm
- toggle dap virtual text
- Nvim doesnt exit properly, searching in git log fails, not disposing running gdb server
- toggleterm doesnt toggle if processes are not running
- non git dirs break telescope file search if a file is opened
- use trouble keybinds for quickfix
- Create installation guide and dependencies
- harpoon not adding relative file path
- notify if no toggleterm windows available
- searching from telescope in dashboard breaks colors (because lsp is loaded after file is opened?)
- loading session does the same as above
- cppcheck
