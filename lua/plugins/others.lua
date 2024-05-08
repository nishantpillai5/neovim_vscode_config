local plugins = {
  "eandrju/cellular-automaton.nvim",
  "kwakzalver/duckytype.nvim",
  "dstein64/vim-startuptime",
}

local cond_table = require("common.lazy").get_cond_table(plugins)
local get_cond = require("common.lazy").get_cond

return {
  {
    "eandrju/cellular-automaton.nvim",
    cond = get_cond("eandrju/cellular-automaton.nvim", cond_table),
    keys = {
      { "<leader>zf", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Visual.fml" },
    },
  },
  {
    "kwakzalver/duckytype.nvim",
    cond = get_cond("kwakzalver/duckytype.nvim", cond_table),
    keys = {
      { "<leader>zt", "<cmd>DuckyType cpp_keywords<cr>", desc = "Visual.typing_test" },
    },
    config = function()
      require("duckytype").setup({})
    end,
  },
  {
    "dstein64/vim-startuptime",
    cond = get_cond("dstein64/vim-startuptime", cond_table),
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
