local load_plugin = {}

load_plugin["folke/trouble.nvim"] = true
load_plugin["akinsho/nvim-toggleterm.lua"] = true
load_plugin["ryanmsnyder/toggleterm-manager.nvim"] = true

return {
  {
    "folke/trouble.nvim",
    cond = load_plugin["folke/trouble.nvim"],
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>tt", "<cmd>lua require('trouble').toggle()<cr>", desc = "Trouble.toggle" },
      {
        "<leader>tw",
        "<cmd>lua require('trouble').toggle('workspace_diagnostics')<cr>",
        desc = "Trouble.workspace_diagnostics",
      },
      {
        "<leader>td",
        "<cmd>lua require('trouble').toggle('document_diagnostics')<cr>",
        desc = "Trouble.document_diagnostics",
      },
      { "<leader>tq", "<cmd>lua require('trouble').toggle('quickfix')<cr>", desc = "Trouble.quickfix" },
      { "<leader>tl", "<cmd>lua require('trouble').toggle('loclist')<cr>", desc = "Trouble.loclist" },
      -- WARN: replacing LSP zero binding
      {
        "]d",
        "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>",
        desc = "Next.trouble",
      },
      {
        "[d",
        "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>",
        desc = "Previous.trouble",
      },
      -- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
    },
  },
  {
    "akinsho/nvim-toggleterm.lua",
    cond = load_plugin["akinsho/nvim-toggleterm.lua"],
    opts = {
      size = vim.o.columns * 0.4,
      direction = "vertical",
      close_on_exit = false,
      start_in_insert = false,
      hide_numbers = true,
      persist_size = false,
    },
  },
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    cond = load_plugin["ryanmsnyder/toggleterm-manager.nvim"],
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>f;", "<cmd>Telescope toggleterm_manager<cr>", desc = "Find.terminal" },
      { "<leader>;;", "<cmd>lua require('toggleterm').toggle_all(true)<cr>", desc = "Terminal.toggle" },
    },
    config = function()
      local toggleterm_manager = require("toggleterm-manager")
      local actions = toggleterm_manager.actions
      toggleterm_manager.setup({
        mappings = {
          n = {
            ["<CR>"] = { action = actions.toggle_term, exit_on_action = true },
            ["o"] = { action = actions.create_and_name_term, exit_on_action = true },
            ["i"] = { action = actions.create_term, exit_on_action = true },
            ["x"] = { action = actions.delete_term, exit_on_action = false },
          },
        },
      })
    end,
  },
}
