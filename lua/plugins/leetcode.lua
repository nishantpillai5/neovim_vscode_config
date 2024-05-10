local plugins = {
    "kawre/leetcode.nvim",
}

local conds = require("common.lazy").get_conds(plugins)
local leet_arg = "leet"

return {
  {
    "kawre/leetcode.nvim",
    cond = conds["kawre/leetcode.nvim"] or false,
    lazy = leet_arg ~= vim.fn.argv()[1],
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = { arg = leet_arg },
  },
}
