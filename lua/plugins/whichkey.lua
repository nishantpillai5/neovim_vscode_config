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
      local wk = require("which-key")
      wk.register({
        ["<leader>"] = {
          ["<space>"] = "hop",
          [";"] = "Terminal",
          r = "Refactor",
          l = "LSP",
          c = "Chat",
          f = "Find",
          e = "File Explorer",
          w = "Workspace/Session",
          t = "Trouble",
          d = "Debug",
          o = "Tasks",
          z = "Visual",
          g = {
            name = "Git",
            h = { name = "Hunk" },
          },
          ["/"] = "Search",
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
        ["[d"] = "prev.diagnostic",
        ["]d"] = "next.diagnostic",
        K = "hover",
      })

      wk.register({
        ["<leader>"] = {
          c = "Chat",
          g = { name = "Git", h = "Hunk" },
          l = "LSP",
          ["/"] = "Search",
        },
      }, { mode = "v" })
    end,
  },
}
