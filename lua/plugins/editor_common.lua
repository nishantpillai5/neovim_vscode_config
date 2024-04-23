return {
    {
        'smoka7/hop.nvim',
        opts = {
            multi_windows = true,
            uppercase_labels = true,
            jump_on_sole_occurrence = false,
        },
        keys = {
            { "<leader><space>", "<cmd>HopChar2<cr>", desc = "hop" },
        }
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
