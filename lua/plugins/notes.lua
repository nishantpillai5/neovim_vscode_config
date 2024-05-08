local plugins = {
  -- "obsidian.nvim", -- WARN: not tested
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "epwalsh/obsidian.nvim",
    cond = conds["obsidian.nvim"] or false,
    version = "*",
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      ui = {
        enable = false,
      },
      workspaces = {
        {
          name = "notes",
          path = "~/notes/notes",
        },
      },
    },
  },
}
