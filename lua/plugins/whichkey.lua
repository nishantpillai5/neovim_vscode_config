local load_plugin = {}
load_plugin["folke/which-key.nvim"] = true

return {
  {
    "folke/which-key.nvim",
    cond = load_plugin["folke/which-key.nvim"],
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      -- TODO: update to only define prefixes
      local wk = require("which-key")
      wk.register({
        ["<leader>"] = {
          ["<space>"] = "hop",
          [";"] = { name = "Terminal" },
          r = { name = "Refactor" },
          l = { name = "LSP", c = { name = "Chat"} },
          f = {
            name = "Find",
            d = "debug tasks",
          },
          e = { name = "File Explorer" },
          w = { name = "Workspace/Session" },
          t = { name = "Trouble" },
          d = { name = "Debug" },
          o = { name = "Tasks" },
          z = { name = "Visual" },
          g = { name = "Git" },
        },
        g = {
          d = "definition",
          D = "declaration",
          i = "implementation",
          o = "symbol",
          r = "references",
          h = "signature help",
          l = "diagnostics",
        },
        ["[d"] = "previous diagnostic",
        ["]d"] = "next diagnostic",
        K = "hover",
      })
    end,
  },
}
