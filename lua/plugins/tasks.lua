return {
    -- Build and Run
    {
        'stevearc/overseer.nvim',
        opts = {},
        config = function()
            require('overseer').setup({
                strategy = "toggleterm",
                dap = false,
            })
            vim.keymap.set("n", "<leader>bb", "<cmd>OverseerRun<CR>")
            vim.keymap.set("n", "<leader>bt", "<cmd>OverseerToggle<CR>")
        end,
    },
    {
        'mfussenegger/nvim-dap',
        dependencies = { 'stevearc/overseer.nvim' },
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
            -- vim.keymap.set("n", "<leader>ds", function() require("dap").toggle_breakpoint() end)
            vim.keymap.set("n", "<leader>dx", function() require("dap").stop() end)
            -- vim.keymap.set("n", "<leader>dr", function() require("dap").toggle_breakpoint() end)

            vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end)
            vim.keymap.set("n", "<leader>dp", function() require("dap").pause() end)
            vim.keymap.set("n", "<leader>dj", function() require("dap").step_into() end)
            vim.keymap.set("n", "<leader>dk", function() require("dap").step_out() end)
            vim.keymap.set("n", "<leader>dl", function() require("dap").step_over() end)
            vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end)
            vim.keymap.set('n', '<Leader>dB', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
        config = function()
            require("dapui").setup()
            vim.keymap.set("n", "<leader>dt", function() require("dapui").toggle() end)
        end
    }
}