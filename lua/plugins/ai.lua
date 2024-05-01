local load_plugin = {}
load_plugin["github/copilot.vim"] = true
load_plugin["CopilotC-Nvim/CopilotChat.nvim"] = true

return {
  {
    "github/copilot.vim",
    cond = load_plugin["github/copilot.vim"],
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      show_help = "yes",
      debug = false,
      disable_extra_info = "no",
      language = "English",
    },
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    event = "VeryLazy",
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Chat.toggle" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Chat.explain" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Chat.fix" },
      { "<leader>cd", "<cmd>CopilotChatFixDiagnostic<cr>", mode = { "n", "v" }, desc = "Chat.fix_diagnositic" },
      { "<leader>cx", "<cmd>CopilotChatReset<cr>", desc = "Chat.reset" },
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
  },
}
