local M = {}

M.keymaps = function ()
  vim.keymap.set({ "n", "v" }, "<leader>ls", function()
    require("conform").format({
      lsp_fallback = true,
      async = true,
      timeout_ms = 500,
    }, function()
      vim.notify("Formatted")
    end)
  end)
end

M.setup = function ()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      json = { "prettier" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      ["_"] = { "trim_whitespace" },
    },
  })
  require("mason-conform").setup()
end

return M
