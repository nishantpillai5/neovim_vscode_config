local plugins = {
  -- "obsidian.nvim", -- WARN: not tested
}

local cond_table = require("common.lazy").get_cond_table(plugins)
local get_cond = require("common.lazy").get_cond

return {
  {
    "epwalsh/obsidian.nvim",
    cond = get_cond("obsidian.nvim", cond_table),
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
