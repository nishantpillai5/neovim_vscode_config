local plugins = {
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "mfussenegger/nvim-dap-python"
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "mfussenegger/nvim-dap",
    cond = conds["mfussenegger/nvim-dap"] or false,
    dependencies = {
      "stevearc/overseer.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "ofirgall/goto-breakpoints.nvim",
    },
    keys = {
      { "<F5>", desc = "Dap.continue/start" },
      { "<C-F5>", desc = "Dap.stop" },
      { "<F6>", desc = "Dap.pause" },
      { "<F7>", desc = "Dap.step_into" },
      { "<C-F7>", desc = "Dap.step_out" },
      { "<F8>", desc = "Dap.step_over" },
      { "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Dap.breakpoint" },
      {
        "<leader>B",
        "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
        desc = "Dap.breakpoint_with_message",
      },
      { "<leader>dt", desc = "Dap.toggle" },
      { "[b", "<cmd>lua require('goto-breakpoints').prev()<cr>", desc = "Prev.breakpoint" },
      { "]b", "<cmd>lua require('goto-breakpoints').next()<cr>", desc = "Next.breakpoint" },
      -- { "<leader>zd","<cmd>DapVirualTextToggle<cr>", desc = "Visual.debug_virtual_toggle" }, -- TODO: doesn't hide, just stop refresh
    },
    config = function()
      local dap = require("dap")
      require("dap.ext.vscode").json_decode = require("overseer.json").decode
      require("dap.ext.vscode").load_launchjs()
      require("overseer").patch_dap(true)
      require("nvim-dap-virtual-text").setup({
        only_first_definition = false,
        all_references = true,
      })

      vim.g.dap_virtual_text = true

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "@error", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "󰰍", texthl = "@error", linehl = "", numhl = "" })

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "C:\\Data\\Other\\cpptools-win64\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe",
        options = {
          detached = false,
        },
      }

      -- Keymaps
      vim.keymap.set("n", "<F5>", function()
        if vim.fn.filereadable(".vscode/launch.json") then
          require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp" } })
        end
        -- vim.notify("DAP: Continue")
        require("dap").continue()
      end)

      vim.keymap.set("n", "<C-F5>", function()
        vim.notify("DAP: Stop")
        require("dap").close()
      end)

      vim.keymap.set("n", "<F6>", function()
        vim.notify("DAP: Pause")
        require("dap").pause()
      end)

      vim.keymap.set("n", "<F7>", function()
        vim.notify("DAP: Step Into")
        require("dap").step_into()
      end)

      vim.keymap.set("n", "<C-F7>", function()
        vim.notify("DAP: Step Out")
        require("dap").step_out()
      end)

      vim.keymap.set("n", "<F8>", function()
        -- vim.notify("DAP: Step Over")
        require("dap").step_over()
      end)

      vim.keymap.set({ "n", "v" }, "<leader>dt", function()
        require("dap.ui.widgets").preview()
      end)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    cond = conds["rcarriga/nvim-dap-ui"] or false,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>dd", "<cmd>lua require('dapui').toggle()<CR>", desc = "Dap.toggle_view" },
      -- { "<leader>dK", "<cmd>lua require('dapui').eval()<cr>", desc = "Dap.eval" },
      {
        "<leader>dK",
        "<cmd>lua require('dapui').eval(vim.fn.expand('<cWORD>'))<cr>",
        mode = "n",
        desc = "Dap.hover",
      },
      -- { "<leader>dK", "<cmd>lua require('dap.ui.variables').visual_hover()<cr>", mode = "v", desc = "Dap.hover" },
      -- { "<leader>d?", "<cmd>lua require('dap.ui.variables').scopes()<cr>", mode = "v", desc = "Dap.hover" },
    },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    cond = conds["mfussenegger/nvim-dap-python"] or false,
    dependencies = { "mfussenegger/nvim-dap" },
    event = "BufEnter *.py",
    config = function ()
       require('dap-python').setup(os.getenv("HOME") .. '/.virtualenvs/debugpy/Scripts/python')
    end,
  },
}
