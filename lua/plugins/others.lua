return {
  {
    "eandrju/cellular-automaton.nvim",
    keys = {
      { "<leader>zf", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Visual.fml" },
    },
  },
  {
    "kwakzalver/duckytype.nvim",
    keys = {
      { "<leader>zt", "<cmd>DuckyType cpp_keywords<cr>", desc = "Visual.typing_test" },
    },
    config = function()
      require("duckytype").setup({})
    end,
  },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
