local M = {}

M.setup = function ()
  require("dashboard").setup({
    theme = "hyper",
    change_to_vcs_root = true,
    config = {
      week_header = {
        enable = true,
      },
      project = { enable = true, limit = 1 },
      mru = { cwd_only = true },
      shortcut = {
        {
          desc = "󱇳 Workspace",
          group = "Number",
          action = "lua require('neoscopes').select()",
          key = "w",
        },
        {
          desc = " Files",
          group = "Label",
          action = "Telescope find_files",
          key = "f",
        },
        {
          desc = "󰊳 Update",
          group = "@property",
          action = "Lazy update",
          key = "u",
        },
      },
      footer = {},
    },
  })
end

return M
