local plugins = {
  "github/copilot.vim",
  "CopilotC-Nvim/CopilotChat.nvim",
}

local cond_table = require("common.lazy").get_cond_table(plugins)
local get_cond = require("common.lazy").get_cond

return {
  {
    "github/copilot.vim",
    cond = get_cond("github/copilot.vim", cond_table),
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = get_cond("CopilotC-Nvim/CopilotChat.nvim", cond_table),
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
