return {
    {
        'smoka7/hop.nvim',
        config = function()
            local hop = require('hop')
            hop.setup({
                multi_windows = true,
                uppercase_labels = true,
                jump_on_sole_occurrence = false,
            })
            vim.keymap.set("n", "<leader><space>", vim.cmd.HopChar2)
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
}