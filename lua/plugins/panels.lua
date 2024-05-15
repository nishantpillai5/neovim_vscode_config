local plugins = {
  "folke/trouble.nvim",
  "akinsho/nvim-toggleterm.lua",
  "ryanmsnyder/toggleterm-manager.nvim",
  "stevearc/overseer.nvim",
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
    keys = {
      { "<leader>;;", desc = "Terminal.toggle" },
    },
    config = function()
      require("toggleterm").setup({
        size = vim.o.columns * 0.35,
        direction = "vertical",
        close_on_exit = true,
        start_in_insert = false,
        hide_numbers = true,
        persist_size = false,
      })

      local init_or_toggle = function()
        local buffers = vim.api.nvim_list_bufs()
        local toggleterm_exists = false
        for _, buf in ipairs(buffers) do
          local buf_name = vim.api.nvim_buf_get_name(buf)
            if buf_name:find("toggleterm") then
              toggleterm_exists = true
              break
          end
        end

        if not toggleterm_exists then
          vim.cmd([[ exe 1 . "ToggleTerm" ]])
        else
          require('toggleterm').toggle_all(true)
        end
      end

      vim.keymap.set("n", "<leader>;;", init_or_toggle, { desc = "Terminal.toggle", silent = true})
    end,
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
  {
    "stevearc/overseer.nvim",
    cond = conds["stevearc/overseer.nvim"] or false,
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
      "nvim-telescope/telescope.nvim",
      "stevearc/dressing.nvim"
    },
    keys = {
      { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Tasks.run" },
      { "<leader>ot", "<cmd>OverseerToggle left<cr>", desc = "Tasks.toggle" },
      { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "Tasks.restart_last" },
    },
    config = function()
      require("overseer").setup({
        strategy = {
          "toggleterm",
          open_on_start = true,
        },
        dap = false,
        task_list = {
          width = 0.1,
          bindings = {
            ["L"] = "IncreaseDetail",
            ["H"] = "DecreaseDetail",
            ["<C-l>"] = false,
            ["<C-h>"] = false,
          },
        },
      })
      vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
        end
      end, {})

      -- Lualine 
      local lualineX = require("lualine").get_config().tabline.lualine_x or {}
      table.insert(lualineX, { "overseer" })

      require("lualine").setup {
        extensions = { "overseer", "nvim-dap-ui" },
        tabline = { lualine_x = lualineX },
      }

    end,
  },
}
