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

- [ ] cpplint
- [ ] copilot chat with selection
- [ ] searching from telescope in dashboard breaks colors (because lsp is loaded after file is opened?)
- [ ] loading session does the same as above
- [ ] refresh scope with a callback instead of a keybind
- [ ] notify if no toggleterm windows available
