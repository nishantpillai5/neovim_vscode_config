return {
    {
        'stevearc/overseer.nvim',
        keys = {
            { "<leader>bb", "<cmd>OverseerRun<cr>", desc = "tasks" },
            { "<leader>bt", "<cmd>OverseerToggle(right)<cr>", desc = "toggle task list" },
        },
        config = function()
            require('overseer').setup({
                strategy = "toggleterm",
                dap = false,
            })
        end,
    },
    {
        'mfussenegger/nvim-dap',
        dependencies = { 'stevearc/overseer.nvim' },
        keys = {
            -- { "<leader>dr", "<cmd>lua require('dap').stop()<cr>", desc = "run w/o debug" },
            -- { "<leader>ds", "<cmd>lua require('dap').stop()<cr>", desc = "start" },
            { "<leader>dx", "<cmd>lua require('dap').stop()<cr>", desc = "stop" },
            { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "continue" },
            { "<leader>dp", "<cmd>lua require('dap').pause()<cr>", desc = "pause" },
            { "<leader>dj", "<cmd>lua require('dap').step_into()<cr>", desc = "step into" },
            { "<leader>dk", "<cmd>lua require('dap').step_out()<cr>", desc = "step out" },
            { "<leader>dl", "<cmd>lua require('dap').step_over()<cr>", desc = "step over" },
            { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "breakpoint" },
            { "<leader>dB", "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", desc = "breakpoint w/ message" },
        },
        config = function()
            local dap = require('dap')
            require("dap.ext.vscode").json_decode = require("overseer.json").decode
            require("dap.ext.vscode").load_launchjs()
            require("overseer").patch_dap(true)

            dap.adapters.cppdbg = {
                id = 'cppdbg',
                type = 'executable',
                command = 'C:\\Data\\Other\\cpptools-win64\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
                options = {
                    detached = false
                }
            }

            -- dap.configurations.cpp = {
            --     {
            --         name = "Launch file",
            --         type = "cppdbg",
            --         request = "launch",
            --         program = function()
            --           return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            --         end,
            --         cwd = '${workspaceFolder}',
            --         stopAtEntry = true,
            --     },
            --     {
            --         name = 'Attach to gdbserver :2000',
            --         type = 'cppdbg',
            --         request = 'launch',
            --         MIMode = 'gdb',
            --         miDebuggerServerAddress = 'localhost:2000',
            --         miDebuggerPath = '/usr/bin/gdb',
            --         cwd = '${workspaceFolder}',
            --         program = function()
            --             return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            --         end,
            --     },
            -- }

            -- dap.configurations.c = dap.configurations.cpp
            -- Keymaps
            vim.keymap.set({'n', 'v'}, '<leader>dd', function()
                require('dap.ui.widgets').preview()
            end)
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        keys = {
            { "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>", desc = "toggle debug view" },
        },
        config = function()
            require("dapui").setup()
        end
    }
}
