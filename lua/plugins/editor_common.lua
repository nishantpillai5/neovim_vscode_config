local plugins = {
  "smoka7/hop.nvim",
  "kylechui/nvim-surround",
}

local cond_table = require("common.lazy").get_cond_table(plugins)
local get_cond = require("common.lazy").get_cond

return {
  {
    "smoka7/hop.nvim",
    cond = get_cond("smoka7/hop.nvim", cond_table),
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
    cond = get_cond("kylechui/nvim-surround", cond_table),
    event = "VeryLazy",
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
}
