local plugins = {
  "nvim-neo-tree/neo-tree.nvim",
  "stevearc/oil.nvim",
  "liuchengxu/vista.vim",
}

local cond_table = require("common.lazy").get_cond_table(plugins)
local get_cond = require("common.lazy").get_cond

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = get_cond("nvim-neo-tree/neo-tree.nvim", cond_table),
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>ee", "<cmd>Neotree reveal focus toggle<cr>", desc = "Explorer.neotree" },
    },
  },
  {
    "stevearc/oil.nvim",
    cond = get_cond("stevearc/oil.nvim", cond_table),
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>eee", "<cmd>Oil<cr>", desc = "Explorer.oil" },
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
    cond = get_cond("liuchengxu/vista.vim", cond_table),
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
