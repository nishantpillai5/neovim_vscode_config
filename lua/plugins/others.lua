return {
  {
    "eandrju/cellular-automaton.nvim",
    keys = {
      { "<leader>zf", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "make it rain" },
    },
  },
  {
    "kwakzalver/duckytype.nvim",
    keys = {
      { "<leader>zt", "<cmd>DuckyType cpp_keywords<cr>", desc = "practise typing" },
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
