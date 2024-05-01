local load_plugin = {}
load_plugin["smoka7/hop.nvim"] = true
load_plugin["kylechui/nvim-surround"] = true

return {
  {
    "smoka7/hop.nvim",
    cond = load_plugin["smoka7/hop.nvim"],
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
    cond = load_plugin["kylechui/nvim-surround"],
    event = "VeryLazy",
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
}
