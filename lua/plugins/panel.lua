local plugins = {
  "folke/trouble.nvim",
  "akinsho/nvim-toggleterm.lua",
  "ryanmsnyder/toggleterm-manager.nvim",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "folke/trouble.nvim",
    cond = conds["folke/trouble.nvim"] or false,
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
    cond = conds["akinsho/nvim-toggleterm.lua"] or false,
    opts = {
      size = vim.o.columns * 0.3,
      direction = "vertical",
      close_on_exit = true,
      start_in_insert = false,
      hide_numbers = true,
      persist_size = false,
      -- auto_scroll = false,
    },
  },
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    cond = conds["ryanmsnyder/toggleterm-manager.nvim"] or false,
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
