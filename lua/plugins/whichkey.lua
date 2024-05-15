local plugins = {
  "folke/which-key.nvim",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "folke/which-key.nvim",
    cond = conds["folke/which-key.nvim"] or false,
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
          c = { name = "Chat", t = "Terminal" },
          f = { name = "Find", g = "Git" },
          e = "Explorer",
          w = "Workspace/Session",
          t = "Trouble",
          b = "Breakpoint",
          n = "Notes",
          o = "Build",
          q = "Quarto",
          z = { name = "Visual", c = "Context", g = "Git" },
          g = { name = "Git", h = "Hunk" },
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
        d = { m = { name = "+Marks" }},
        m = {
          name = "+Marks",
          [";"] = "Marks.mark_toggle",
          [","] = "Marks.mark_set",
        },
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
