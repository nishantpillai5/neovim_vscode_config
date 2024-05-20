local M = {}

function M.map(mode, key, action)
  vim.api.nvim_set_keymap(
    mode,
    key,
    ":lua require('vscode-neovim').call('" .. action .. "')<CR>",
    { noremap = true, silent = true }
  )
end

return M
