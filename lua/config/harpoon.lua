local M = {}

M.keymaps = function ()
  local harpoon = require("harpoon")
  vim.keymap.set("n", "<leader>a", function()
    harpoon:list():add()
  end, { desc = "harpoon_add" })
  vim.keymap.set("n", "<leader>h", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, { desc = "harpoon_list" })
  vim.keymap.set("n", "<C-PageUp>", function()
    harpoon:list():prev()
  end, { desc = "harpoon_prev" })
  vim.keymap.set("n", "<C-PageDown>", function()
    harpoon:list():next()
  end, { desc = "harpoon_next" })
end

M.lualine = function ()
  local lualineC = require("lualine").get_config().sections.lualine_c or {}
  table.insert(lualineC, { "harpoon2" })

  require("lualine").setup {
    sections = { lualine_c = lualineC },
  }
end

M.setup = function ()
  local harpoon = require("harpoon")
  harpoon:setup()
end

return M
