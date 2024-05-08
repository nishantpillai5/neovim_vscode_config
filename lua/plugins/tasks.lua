local plugins = {
  "stevearc/overseer.nvim",
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
}

local cond_table = require("common.lazy").get_cond_table(plugins)
local get_cond = require("common.lazy").get_cond

return {
  {
    "stevearc/overseer.nvim",
    cond = get_cond("stevearc/overseer.nvim", cond_table),
    keys = {
      { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Tasks.run" },
      { "<leader>ot", "<cmd>OverseerToggle left<cr>", desc = "Tasks.toggle" },
      { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "Tasks.restart_last" },
    },
    config = function()
      require("overseer").setup({
        strategy = "toggleterm",
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
    end,
  },
  {
    "mfussenegger/nvim-dap",
    cond = get_cond("mfussenegger/nvim-dap", cond_table),
    dependencies = {
      "stevearc/overseer.nvim",
      "theHamsta/nvim-dap-virtual-text",
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
        -- require("notify")("DAP: Continue")
        require("dap").continue()
      end)

      vim.keymap.set("n", "<C-F5>", function()
        require("notify")("DAP: Stop")
        require("dap").close()
      end)

      vim.keymap.set("n", "<F6>", function()
        require("notify")("DAP: Pause")
        require("dap").pause()
      end)

      vim.keymap.set("n", "<F7>", function()
        require("notify")("DAP: Step Into")
        require("dap").step_into()
      end)

      vim.keymap.set("n", "<C-F7>", function()
        require("notify")("DAP: Step Out")
        require("dap").step_out()
      end)

      vim.keymap.set("n", "<F8>", function()
        -- require("notify")("DAP: Step Over")
        require("dap").step_over()
      end)

      vim.keymap.set({ "n", "v" }, "<leader>dt", function()
        require("dap.ui.widgets").preview()
      end)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    cond = get_cond("rcarriga/nvim-dap-ui", cond_table),
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
}
