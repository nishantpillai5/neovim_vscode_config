return {
    -- Start page
    {
        'goolord/alpha-nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            require'alpha'.setup(require'alpha.themes.startify'.config)
        end
    },
    -- Finder
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
            vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            -- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end,
    },
    -- Sidebar
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        config = function()
            vim.keymap.set("n", "<leader>ee", "<cmd>Neotree reveal show toggle<CR>")
            -- vim.keymap.set("n", "<leader>ex", "<cmd>Neotree toggle<CR>")
        end,
    },
    -- Misc
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end,
    },
    "sitiom/nvim-numbertoggle",
    "jiangmiao/auto-pairs",
}