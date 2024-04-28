return {
  {
    "smartpde/neoscopes",
    keys = {
      { "<leader>fw", desc = "Find.workspace" },
      { "<leader>ww", desc = "Workspace.refresh" },
      { "<leader>wx", desc = "Workspace.close" },
    },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local neoscopes = require("neoscopes")
      neoscopes.setup({})

      local refresh_workspace = function()
        local current_scope = neoscopes.get_current_scope()
        if current_scope == nil then
          require("notify")("󱇳 No scope selected")
          local builtin = require("telescope.builtin")
          vim.keymap.set("n", "<leader>ff", builtin.git_files)
          vim.keymap.set("n", "<leader>fg", function()
            builtin.live_grep({ grep_open_files = true })
          end)
          vim.keymap.set("n", "<leader>f/", function()
            builtin.grep_string({ search = vim.fn.input("Search > ") })
          end)
        else
          require("notify")("Scope refreshed: 󱇳 " .. neoscopes.get_current_scope().name)

          local builtin = require("telescope.builtin")

          _G.find_files = function()
            builtin.find_files({
              prompt_prefix = "󱇳 > ",
              search_dirs = neoscopes.get_current_dirs(),
            })
          end
          _G.live_grep = function()
            builtin.live_grep({
              prompt_prefix = "󱇳 > ",
              search_dirs = neoscopes.get_current_dirs(),

              additional_args = { "--follow" },
            })
          end
          _G.grep_string = function()
            builtin.grep_string({
              prompt_prefix = "󱇳 > ",
              search = vim.fn.input("Search > "),
              search_dirs = neoscopes.get_current_dirs(),
              additional_args = { "--follow" },
            })
          end

          vim.api.nvim_set_keymap("n", "<leader>ff", ":lua find_files()<CR>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<leader>fg", ":lua live_grep()<CR>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<leader>f/", ":lua grep_string()<CR>", { noremap = true })
        end
      end

      vim.keymap.set("n", "<leader>fw", function()
        neoscopes.setup({})
        neoscopes.select()
      end)

      vim.keymap.set("n", "<leader>ww", function()
        refresh_workspace()
      end)
      vim.keymap.set("n", "<leader>wx", function()
        neoscopes.clear()
        refresh_workspace()
      end)
    end,
  },
  {
    "stevearc/resession.nvim",
    keys = {
      { "<leader>ws", desc = "Workspace.session_save" },
      { "<leader>wl", desc = "Workspace.session_load" },
      { "<leader>wS", "<cmd>lua require('resession').save()<cr>", desc = "Workspace.manual_session_save" },
      { "<leader>wL", "<cmd>lua require('resession').load()<cr>", desc = "Workspace.manual_session_load" },
      { "<leader>wd", "<cmd>lua require('resession').delete()<cr>", desc = "Workspace.session_delete" },
    },

    config = function()
      local recession = require("resession")
      recession.setup({})

      local workspace_session = function(action)
        local status, neoscopes = pcall(require, "neoscopes")
        if status then
          local current_scope = neoscopes.get_current_scope()
          if current_scope ~= nil then
            action(current_scope.name)
            require("notify")("Session: " .. current_scope.name)
          else
            action("workspace")
            require("notify")("Session: workspace")
          end
        else
          action("workspace")
          require("notify")("Session: workspace")
        end
      end

      vim.keymap.set("n", "<leader>ws", function()
        workspace_session(recession.save)
      end)

      vim.keymap.set("n", "<leader>wl", function()
        workspace_session(recession.load)
      end)
    end,
  },
}
