local load_plugin = {}

load_plugin["nvim-neo-tree/neo-tree.nvim"] = true
load_plugin["stevearc/oil.nvim"] = true
load_plugin["liuchengxu/vista.vim"] = true

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = load_plugin["nvim-neo-tree/neo-tree.nvim"],
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>ee", "<cmd>Neotree reveal focus toggle<cr>", desc = "Explorer.neotree" },
    },
  },
  {
    "stevearc/oil.nvim",
    cond = load_plugin["stevearc/oil.nvim"],
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
    cond = load_plugin["liuchengxu/vista.vim"],
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
