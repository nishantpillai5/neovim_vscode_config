local plugins = {
  "obsidian.nvim",
}

local conds = require("common.lazy").get_conds(plugins)
local NOTES_DIR = require("common.env").NOTES_DIR

return {
  {
    "epwalsh/obsidian.nvim",
    cond = conds["obsidian.nvim"] or false,
    version = "*",
    cmd = {"ObsidianToday"},
    -- event = {
    --   "BufReadPre " .. NOTES_DIR .. "/**.md",
    --   "BufNewFile " .. NOTES_DIR .. "/**.md",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "preservim/vim-markdown"
    },
    opts = {
      ui = {
        enable = false,
      },
      workspaces = {
        {
          name = "notes",
          path = NOTES_DIR,
        },
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
      daily_notes = {
        folder = "dailies",
        date_format = "%Y.%m.%d",
        template = "daily.md"
      },
    },
  },
}
