local M = {}

M.keymaps = function ()
  vim.keymap.set("n", "<leader>ft", function()
    if not _G.loaded_telescope_extension then
      require("telescope").load_extension("dap")
      require("telescope").load_extension("conflicts")
      -- require("telescope").load_extension("yank_history")
      -- require("telescope").load_extension("refactoring")
      require("telescope").load_extension("notify")
      require("telescope").load_extension("picker_list")
      _G.loaded_telescope_extension = true
    end
    require("telescope").extensions.picker_list.picker_list()
  end, { desc = "Find.telescope" })
end

return M
