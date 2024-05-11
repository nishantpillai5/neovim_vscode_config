local plugins = {
  "smoka7/hop.nvim",
  "kylechui/nvim-surround",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "smoka7/hop.nvim",
    cond = conds["smoka7/hop.nvim"] or false,
    keys = {
      { "<leader><space>", "<cmd>HopChar2<cr>", desc = "hop" },
    },
    opts = {
      multi_windows = true,
      uppercase_labels = true,
      jump_on_sole_occurrence = false,
    },
  },
  {
    "kylechui/nvim-surround",
    cond = conds["kylechui/nvim-surround"] or false,
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
}
