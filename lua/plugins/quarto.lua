local plugins = {
  -- "quarto-dev/quarto-nvim",
  -- "jmbuhr/otter.nvim",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "quarto-dev/quarto-nvim",
    cond = conds["quarto-dev/quarto-nvim"] or false,
    ft = "quarto",
    dependencies = {
      "jmbuhr/otter.nvim",
    },
    opts = {
      lspFeatures = {
        languages = { "r", "python", "julia", "bash", "html", "lua" },
      },
    },
    keys = {
      { "<leader>qa", ":QuartoActivate<cr>", desc = "quarto activate" },
      { "<leader>qp", ":lua require'quarto'.quartoPreview()<cr>", desc = "quarto preview" },
      { "<leader>qq", ":lua require'quarto'.quartoClosePreview()<cr>", desc = "quarto close" },
      { "<leader>qh", ":QuartoHelp ", desc = "quarto help" },
      { "<leader>qe", ":lua require'otter'.export()<cr>", desc = "quarto export" },
      { "<leader>qE", ":lua require'otter'.export(true)<cr>", desc = "quarto export overwrite" },
      { "<leader>qrr", ":QuartoSendAbove<cr>", desc = "quarto run to cursor" },
      { "<leader>qra", ":QuartoSendAll<cr>", desc = "quarto run all" },
      { "<leader><cr>", ":SlimeSend<cr>", desc = "send code chunk" },
      { "<c-cr>", ":SlimeSend<cr>", desc = "send code chunk" },
      { "<c-cr>", "<esc>:SlimeSend<cr>i", mode = "i", desc = "send code chunk" },
      { "<c-cr>", "<Plug>SlimeRegionSend<cr>", mode = "v", desc = "send code chunk" },
      { "<cr>", "<Plug>SlimeRegionSend<cr>", mode = "v", desc = "send code chunk" },
      { "<leader>ctr", ":split term://R<cr>", desc = "terminal: R" },
      { "<leader>cti", ":split term://ipython<cr>", desc = "terminal: ipython" },
      { "<leader>ctp", ":split term://python<cr>", desc = "terminal: python" },
      { "<leader>ctj", ":split term://julia<cr>", desc = "terminal: julia" },
    },
  },
  {
    "jmbuhr/otter.nvim",
    cond = conds["jmbuhr/otter.nvim"] or false,
    lazy = true,
    opts = {
      buffers = {
        set_filetype = true,
      },
    },
  },
}
