return {
  {
    "folke/which-key.nvim",
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
          [";"] = {
            name = "Terminal",
            t = "toggle",
          },
          r = {
            name = "Refactor",
          },
          f = {
            name = "Find",
            d = "debug tasks",
          },
          e = { name = "File Explorer" },
          w = { name = "Workspace/Session" },
          t = { name = "Trouble" },
          d = {
            name = "Debug",
            d = "preview",
            t = "toggle view",
            s = "start",
            x = "stop",
            r = "run with debug",
            c = "continue",
            p = "pause",
            j = "step into",
            k = "step out",
            l = "step over",
            b = "breakpoint",
            B = "breakpoint w/ message",
          },
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
        gs = {
          name = "Git",
          s = "fugitive",
          l = "lazy",
        },
        ["[d"] = "previous diagnostic",
        ["d"] = "next diagnostic",
        K = "hover",
        ["<F2>"] = "rename",
        ["<F3>"] = "format",
      })
    end,
  },
}
