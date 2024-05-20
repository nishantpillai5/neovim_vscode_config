local M = {}

M.keymaps = function ()
  vim.keymap.set("n", "<leader>zn", function()
    require("noice").cmd("disable")
  end, { desc = "Visual.notifications_disable" })
end

M.setup = function ()
  require("noice").setup({
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    presets = {
      bottom_search = false,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
  })
end

return M
