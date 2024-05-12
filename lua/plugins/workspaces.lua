local plugins = {
  "smartpde/neoscopes",
  "stevearc/resession.nvim",
  -- "niuiic/multiple-session.nvim", --TODO: supports saving breakpoint
  "aymericbeaumet/vim-symlink",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "aymericbeaumet/vim-symlink",
    cond = conds["aymericbeaumet/vim-symlink"] or false,
    dependencies = { "moll/vim-bbye" },
    event = "VeryLazy",
  },
  {
    "smartpde/neoscopes",
    cond = conds["smartpde/neoscopes"] or false,
    keys = {
      { "<leader>ww", desc = "Find.workspace" },
      { "<leader>wx", desc = "Workspace.close" },
    },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local neoscopes = require("neoscopes")
      -- Helper functions
      local neoscopes_keymaps = function()
        vim.keymap.set("n", "<leader>ff", function()
          require("telescope.builtin").find_files({
            prompt_prefix = "󱇳 > ",
            search_dirs = neoscopes.get_current_dirs(),
          })
        end, { desc = "Find.files(workspace)" })
        -- remapping fa, f/, fgg not needed

        vim.keymap.set("n", "<leader>fl", function()
          require("telescope.builtin").live_grep({
            search_dirs = neoscopes.get_current_dirs(),
            additional_args = { "--follow" },
          })
        end, { desc = "Find.Live_grep.global(workspace)" })

        vim.keymap.set("n", "<leader>f?", function()
          require("telescope.builtin").grep_string({
            prompt_prefix = "󱇳 > ",
            search = vim.fn.input("Search > "),
            search_dirs = neoscopes.get_current_dirs(),
            additional_args = { "--follow" },
          })
        end, { desc = "Find.Search.global(workspace)" })

        vim.keymap.set("n", "<leader>fw", function()
          local word = vim.fn.expand("<cword>")
          require("telescope.builtin").grep_string({
            search = word,
            search_dirs = neoscopes.get_current_dirs(),
            additional_args = { "--follow" },
          })
        end, { desc = "Find.word(workspace)" })

        vim.keymap.set("n", "<leader>fW", function()
          local word = vim.fn.expand("<cWORD>")
          require("telescope.builtin").grep_string({
            search = word,
            search_dirs = neoscopes.get_current_dirs(),
            additional_args = { "--follow" },
          })
        end, { desc = "Find.whole_word(workspace)" })
      end

      -- Remap Telescope
      local refresh_workspace = function()
        local current_scope = neoscopes.get_current_scope()
        if current_scope == nil then
          vim.notify("󱇳 No scope selected")
          _G.Telescope_keymaps()
        else
          vim.notify("Scope selected: 󱇳 " .. neoscopes.get_current_scope().name)
          neoscopes_keymaps()
        end
      end

      -- Setup
      neoscopes.setup({ on_scope_selected = refresh_workspace })

      -- Keymaps
      vim.keymap.set("n", "<leader>ww", function()
        neoscopes.setup({ on_scope_selected = refresh_workspace })
        neoscopes.select()
      end)

      vim.keymap.set("n", "<leader>wx", function()
        neoscopes.clear()
        refresh_workspace()
      end)

      -- Lualine
      local function lualine_status()
        local current_scope = neoscopes.get_current_scope()
        if current_scope == nil then
          return "󱇳 "
        end

        return "󱇳 " .. neoscopes.get_current_scope().name
      end

      local lualineZ = require("lualine").get_config().tabline.lualine_z or {}
      table.insert(lualineZ, { lualine_status })

      require("lualine").setup {
        tabline = { lualine_z = lualineZ },
      }
    end,
  },
  {
    "stevearc/resession.nvim",
    cond = conds["stevearc/resession.nvim"] or false,
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
            vim.notify("Session: " .. current_scope.name)
          else
            action("workspace")
            vim.notify("Session: workspace")
          end
        else
          action("workspace")
          vim.notify("Session: workspace")
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
  {
    "niuiic/multiple-session.nvim",
    cond = conds["niuiic/multiple-session.nvim"] or false,
    dependencies = { "niuiic/core.nvim" },
    keys = {
      { "<leader>ws", function() require('multiple-session').save_session() end, desc = "Workspace.session_save" },
      { "<leader>wl", function () require('multiple-session').restore_session() end, desc = "Workspace.session_load" },
      -- { "<leader>wS", "<cmd>lua require('resession').save()<cr>", desc = "Workspace.manual_session_save" },
      -- { "<leader>wL", "<cmd>lua require('resession').load()<cr>", desc = "Workspace.manual_session_load" },
      { "<leader>wd", function() require('multiple-session').delete_session() end, desc = "Workspace.session_delete" },
    },
    opts = {
      -- auto_save_session = false,
      -- auto_load_session = false,
    }
  },
}
