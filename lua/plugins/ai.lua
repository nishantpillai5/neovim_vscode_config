local plugins = {
  "github/copilot.vim",
  "CopilotC-Nvim/CopilotChat.nvim",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "github/copilot.vim",
    cond = conds["github/copilot.vim"] or false,
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = conds["CopilotC-Nvim/CopilotChat.nvim"] or false,
    event = { "BufReadPre", "BufNewFile" },
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Chat.toggle" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Chat.explain" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Chat.fix" },
      { "<leader>cd", "<cmd>CopilotChatFixDiagnostic<cr>", mode = { "n", "v" }, desc = "Chat.fix_diagnositic" },
      { "<leader>cr", "<cmd>CopilotChatReset<cr>", desc = "Chat.reset" },
      {
        "<leader>cb",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "Chat.buffer",
      },
      {
        "<leader>cc",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").selection })
          end
        end,
        mode = "v",
        desc = "Chat.selection",
      },
      -- {
      --   "<leader>fc",
      --   function()
      --     local actions = require("CopilotChat.actions")
      --     require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
      --   end,
      --   mode = { "n", "v" },
      --   desc = "Find.chat",
      -- },
    },
    config = function()
      require("CopilotChat").setup({
        show_help = "yes",
        debug = false,
        disable_extra_info = "no",
        language = "English",
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          -- C-p to print last response
          vim.keymap.set("n", "<C-p>", function()
            print(require("CopilotChat").response())
          end, { buffer = true, remap = true })
        end,
      })
    end,
  },
}
