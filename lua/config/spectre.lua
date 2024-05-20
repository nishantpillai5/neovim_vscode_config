local M = {}

M.keymaps = function ()
  local spectre = require("spectre ")

  vim.keymap.set("n", "<leader>//", function()
    spectre.open_file_search()
  end, { desc = "Search.local" })

  vim.keymap.set("v", "<leader>//", function()
    spectre.open_file_search({select_word=true})
  end, { desc = "Search.local" })

  vim.keymap.set("n", "<leader>/", function()
    spectre.toggle()
  end, { desc = "Search.global" })

  vim.keymap.set("n", "<leader>/w", function()
    spectre.open_visual({select_word=true})
  end, { desc = "Search.global.word" })

  vim.keymap.set("v", "<leader>/w", function()
    spectre.open_visual()
  end, { desc = "Search.global.word" })

end

return M
