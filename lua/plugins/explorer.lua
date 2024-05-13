local plugins = {
  "nvim-neo-tree/neo-tree.nvim",
  "stevearc/oil.nvim",
  "liuchengxu/vista.vim",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = conds["nvim-neo-tree/neo-tree.nvim"] or false,
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>et", "<cmd>Neotree reveal focus toggle<cr>", desc = "Explorer.neotree" },
    },
  },
  {
    "stevearc/oil.nvim",
    cond = conds["stevearc/oil.nvim"] or false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ee", "<cmd>Oil<cr>", desc = "Explorer.oil" },
    },
    config = function()
      require("oil").setup({
        -- Keep netrw enabled
        default_file_explorer = false,
      })
    end,
  },
  {
    "liuchengxu/vista.vim",
    cond = conds["liuchengxu/vista.vim"] or false,
    keys = {
      { "<leader>eo", "<cmd>Vista!!<cr>", mode = "n", desc = "Explorer.symbols" },
    },
    config = function()
      vim.g.vista_echo_cursor = 0
      vim.g.vista_echo_cursor_strategy = "floating_win"
      vim.g.vista_sidebar_position = "vertical topleft"
      vim.g.vista_cursor_delay = 1500
      vim.g.vista_sidebar_width = 40
    end,
  },
}
