local plugins = {
  "ofirgall/goto-breakpoints.nvim",
  "rcarriga/nvim-dap-ui",
  "mfussenegger/nvim-dap-python"
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "ofirgall/goto-breakpoints.nvim",
    cond = conds["ofirgall/goto-breakpoints.nvim"] or false,
    dependencies = {
      "mfussenegger/nvim-dap",
      "stevearc/overseer.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
    keys = {
      { "<F5>", desc = "Debug.continue/start" },
      { "<C-F5>", desc = "Debug.stop" },
      { "<F6>", desc = "Debug.pause" },
      { "<F7>", desc = "Debug.step_into" },
      { "<C-F7>", desc = "Debug.step_out" },
      { "<F8>", desc = "Debug.step_over" },
      { "<leader>bb", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Breakpoint.toggle" },
      {
        "<leader>bl",
        "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
        desc = "Breakpoint.toggle_with_log",
      },
      -- { "<leader>bt", desc = "Debug.toggle" },
      { "[b", "<cmd>lua require('goto-breakpoints').prev()<cr>", desc = "Prev.breakpoint" },
      { "]b", "<cmd>lua require('goto-breakpoints').next()<cr>", desc = "Next.breakpoint" },
      -- { "<leader>zd","<cmd>DapVirualTextToggle<cr>", desc = "Visual.debug_virtual_toggle" }, -- TODO: doesn't hide, just stops refreshing
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

      require("telescope").load_extension("dap")
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

      -- vim.keymap.set({ "n", "v" }, "<leader>bt", function()
      --   require("dap.ui.widgets").preview()
      -- end)
      vim.keymap.set("n", "<leader>fb", function()

      end, {desc="Find.breakpoint"})

    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    cond = conds["rcarriga/nvim-dap-ui"] or false,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>bt", "<cmd>lua require('dapui').toggle()<CR>", desc = "Breakpoint.toggle_view" },
      -- { "<leader>dK", "<cmd>lua require('dapui').eval()<cr>", desc = "Breakpoint.eval" },
      -- TODO: make dd toggle the K keymap to dap eval instead of hover
      {
        "<leader>bK",
        "<cmd>lua require('dapui').eval(vim.fn.expand('<cWORD>'))<cr>",
        mode = "n",
        desc = "Breakpoint.hover",
      },
      -- { "<leader>dK", "<cmd>lua require('dap.ui.variables').visual_hover()<cr>", mode = "v", desc = "Breakpoint.hover" },
      -- { "<leader>d?", "<cmd>lua require('dap.ui.variables').scopes()<cr>", mode = "v", desc = "Breakpoint.hover" },
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
