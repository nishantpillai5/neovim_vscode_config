return {
    -- Start page
    {
        'goolord/alpha-nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            require('alpha').setup(require'alpha.themes.startify'.config)
        end
    },
    -- Git
    {
        'tpope/vim-fugitive',
        config = function ()
            vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>")
        end
    },
    -- Finder
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
            vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fs', function()
                builtin.grep_string({search = vim.fn.input("Grep > ")})
            end)
            vim.keymap.set('n', '<leader>fws', function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end)
            vim.keymap.set('n', '<leader>fWs', function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end)
            vim.keymap.set('n', '<leader>fo', builtin.lsp_document_symbols, {})
            vim.keymap.set('n', '<leader>fm', builtin.marks, {})
            vim.keymap.set('n', '<leader>fr', builtin.registers, {})
            -- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"},
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end

            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "<leader>fh", function() toggle_telescope(harpoon:list()) end, { desc = "Find Harpoon files" })

            vim.api.nvim_set_keymap('n', '<C-PageUp>', ':lua require("harpoon"):list():prev()<CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<C-PageDown>', ':lua require("harpoon"):list():next()<CR>', {noremap = true, silent = true})
        end,
    },
    -- File Management
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        config = function()
            vim.keymap.set("n", "<leader>ee", "<cmd>Neotree reveal show toggle<CR>")
            -- vim.keymap.set("n", "<leader>ex", "<cmd>Neotree toggle<CR>")
        end,
    },
    {
        'stevearc/oil.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                -- Keep netrw enabled
                default_file_explorer = false,
            })
            vim.keymap.set("n", "<leader>ef", "<cmd>Oil<CR>")
        end,
    },
    -- Panel
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.keymap.set("n", "<leader>tt", function() require("trouble").toggle() end)
            vim.keymap.set("n", "<leader>tw", function() require("trouble").toggle("workspace_diagnostics") end)
            vim.keymap.set("n", "<leader>td", function() require("trouble").toggle("document_diagnostics") end)
            vim.keymap.set("n", "<leader>tq", function() require("trouble").toggle("quickfix") end)
            vim.keymap.set("n", "<leader>tl", function() require("trouble").toggle("loclist") end)
            vim.keymap.set("n", "<leader>tn", function() require("trouble").next({skip_groups = true, jump = true}) end)
            vim.keymap.set("n", "<leader>tp", function() require("trouble").previous({skip_groups = true, jump = true}) end)
            -- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
        end,
    },
    {
        "ryanmsnyder/toggleterm-manager.nvim",
        dependencies = {
            "akinsho/nvim-toggleterm.lua",
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
        },
        config = function()
            local toggleterm_manager = require("toggleterm-manager")
            local actions = toggleterm_manager.actions
            toggleterm_manager.setup {
                mappings = {
                    n = {
                      ["<CR>"] = { action = actions.toggle_term, exit_on_action = true },
                      ["o"] = { action = actions.create_and_name_term, exit_on_action = true },
                      ["i"] = { action = actions.create_term, exit_on_action = true },
                      ["x"] = { action = actions.delete_term, exit_on_action = false },
                    },
                },
            }
            vim.api.nvim_set_keymap('n', '<leader>f;', ':Telescope toggleterm_manager<CR>', {noremap = true, silent = true})
            vim.keymap.set('n', '<leader>;t', function() require('toggleterm').toggle_all(true) end)
        end,
    },
    -- Misc
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end,
    },
    {
        "folke/zen-mode.nvim",
        config = function()
            vim.keymap.set("n", "<leader>zz", function() require("zen-mode").toggle({ window = { width = .85 }}) end)
        end,
    },
    {
        'vladdoster/remember.nvim',
        config = function()
            require("remember").setup({})
        end,
    },
    "sitiom/nvim-numbertoggle",
    -- "jiangmiao/auto-pairs",
}
