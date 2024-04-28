return {
  {
    "folke/which-key.nvim",
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
        gs = { name = "Git" },
        ["[d"] = "previous diagnostic",
        ["]d"] = "next diagnostic",
        K = "hover",
      })
    end,
  },
}
