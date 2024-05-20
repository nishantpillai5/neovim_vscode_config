local M = {}

M.keymaps = function ()
  local align = require("common.env").ALIGN
  vim.keymap.set("n", "<leader>et", function()
    vim.cmd("Neotree reveal focus toggle "..align)
  end, { desc = "Explorer.neotree" })
end

return M
