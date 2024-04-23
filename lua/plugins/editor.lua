return {
    -- Start page
    {
        'nvimdev/dashboard-nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('dashboard').setup({
                theme = 'hyper',
                change_to_vcs_root = true,
                config = {
                    week_header = {
                        enable = true,
                    },
                    shortcut = {
                        { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                        {
                            icon = ' ',
                            icon_hl = '@variable',
                            desc = 'Files',
                            group = 'Label',
                            action = 'Telescope find_files',
                            key = 'f',
                        },
                        {
                            desc = ' Apps',
                            group = 'DiagnosticHint',
                            action = 'Telescope app',
                            key = 'a',
                        },
                        {
                            desc = ' dotfiles',
                            group = 'Number',
                            action = 'Telescope dotfiles',
                            key = 'd',
                        },
                    },
                },
          })
      end,
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    -- Comments
    {
        'numToStr/Comment.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {},
    },
    -- Tmux like navigation
    {
        "alexghergh/nvim-tmux-navigation",
        config = function()
            local nvim_tmux_nav = require('nvim-tmux-navigation')
            nvim_tmux_nav.setup {
                disable_when_zoomed = true -- defaults to false
            }

            vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
            vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
            vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
            vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
            vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
            vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
        end
    },
    -- Git
    {
        'tpope/vim-fugitive',
        keys = {
            { "<leader>gss", "<cmd>Git<cr>", desc = "fugitive" },
        },
    },
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function ()
            require('gitsigns').setup({
                on_attach = function(bufnr)
                    local gitsigns = require('gitsigns')

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                -- Navigation
                map('n', ']c', function()
                  if vim.wo.diff then
                    vim.cmd.normal({']c', bang = true})
                  else
                    gitsigns.nav_hunk('next')
                  end
                end)

                map('n', '[c', function()
                  if vim.wo.diff then
                    vim.cmd.normal({'[c', bang = true})
                  else
                    gitsigns.nav_hunk('prev')
                  end
                end)

                -- Actions
                -- map('n', '<leader>ghs', gitsigns.stage_hunk)
                -- map('n', '<leader>ghr', gitsigns.reset_hunk)
                -- map('v', '<leader>ghs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                -- map('v', '<leader>ghr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                -- map('n', '<leader>ghS', gitsigns.stage_buffer)
                -- map('n', '<leader>ghu', gitsigns.undo_stage_hunk)
                -- map('n', '<leader>ghR', gitsigns.reset_buffer)
                -- map('n', '<leader>ghp', gitsigns.preview_hunk)
                -- map('n', '<leader>ghb', function() gitsigns.blame_line{full=true} end)
                -- map('n', '<leader>gtb', gitsigns.toggle_current_line_blame)
                -- map('n', '<leader>ghd', gitsigns.diffthis)
                -- map('n', '<leader>ghD', function() gitsigns.diffthis('~') end)
                -- map('n', '<leader>gtd', gitsigns.toggle_deleted)

                -- Text object
                -- map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
        })
        end
    },
    -- Finder
    {
        'nvim-telescope/telescope.nvim',
        keys = {
            "<leader>ff",
            "<leader>fa",
            "<leader>fg",
            "<leader>f/",
            "<leader>f/w",
            "<leader>f/W",
            "<leader>fo",
            "<leader>fm",
            "<leader>fr",
            "<leader>fp",
        },
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            require("telescope").load_extension("yank_history")

            vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = "git files" })
            vim.keymap.set('n', '<leader>fa', builtin.find_files, { desc = "all files" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "live grep" })
            vim.keymap.set('n', '<leader>f/', function()
                builtin.grep_string({search = vim.fn.input("Search > ")})
            end, {desc = "+Find string"})
            vim.keymap.set('n', '<leader>f/w', function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end, {desc = "find word"})
            vim.keymap.set('n', '<leader>f/W', function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end, {desc = "find whole word"})
            vim.keymap.set('n', '<leader>fo', builtin.lsp_document_symbols, {desc = "symbols"})
            vim.keymap.set('n', '<leader>fm', builtin.marks, {desc = "marks"})
            vim.keymap.set('n', '<leader>fr', builtin.registers, {desc = "registers"})
            -- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

            vim.keymap.set('n', '<leader>fp', "<cmd>Telescope yank_history<cr>", {desc = "yank history"})
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"},
        keys = {
            "<leader>a",
            "<leader>h",
            "<leader>fh",
            "<C-PageUp>",
            "<C-PageDown>",
        },
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

            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "harpoon add" })
            vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "harpoon list" })
            vim.keymap.set("n", "<leader>fh", function() toggle_telescope(harpoon:list()) end, { desc = "harpoon files" })

            vim.api.nvim_set_keymap('n', '<C-PageUp>', ':lua require("harpoon"):list():prev()<CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<C-PageDown>', ':lua require("harpoon"):list():next()<CR>', {noremap = true, silent = true})
        end,
    },
    {
        "nvim-pack/nvim-spectre",
        keys = {
            { "<leader>/", "<cmd>lua require('spectre').open_file_search()<cr>", mode = "n", desc = "+Search & replace (replace in file)" },
            { "<leader>/", "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>", mode = "v", desc = "replace in file" },
            { "<leader>/f", "<cmd>lua require('spectre').toggle()<cr>", desc = "toggle view" },
            { "<leader>/w", "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", mode = "n", desc = "word" },
            { "<leader>/w", "<cmd>lua require('spectre').open_visual()<cr>", mode = "v", desc = "word" },
        },
    },
    -- File Management
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        keys = {
            { "<leader>ee", "<cmd>Neotree reveal show toggle<cr>", desc = "neotree" },
        }
    },
    {
        'stevearc/oil.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>eo", "<cmd>Oil<cr>", desc = "oil" },
        },
        config = function()
            require("oil").setup({
                -- Keep netrw enabled
                default_file_explorer = false,
            })
        end,
    },
    -- Panel
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>tt", "<cmd>lua require('trouble').toggle()<cr>", desc = "trouble toggle" },
            { "<leader>tw", "<cmd>lua require('trouble').toggle('workspace_diagnostics')<cr>", desc = "workspace diagnostics" },
            { "<leader>td", "<cmd>lua require('trouble').toggle('document_diagnostics')<cr>", desc = "document diagnostics" },
            { "<leader>tq", "<cmd>lua require('trouble').toggle('quickfix')<cr>", desc = "quickfix" },
            { "<leader>tl", "<cmd>lua require('trouble').toggle('loclist')<cr>", desc = "loclist" },
            { "<leader>tn", "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>", desc = "next" },
            { "<leader>tp", "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>", desc = "previous" },
            -- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
        },
    },
    {
        "ryanmsnyder/toggleterm-manager.nvim",
        dependencies = {
            "akinsho/nvim-toggleterm.lua",
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
        },
        keys = {
            { "<leader>f;", "<cmd>Telescope toggleterm_manager<cr>", desc = "find terminal" },
            { "<leader>;t", "<cmd>lua require('toggleterm').toggle_all(true)<cr>", desc = "terminal toggle" },
            { "<leader>gsl" , desc = "lazygit" },
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

            local Terminal  = require('toggleterm.terminal').Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                hidden = true,
                direction = "float",
                float_opts = {
                border = "double",
                },
            })

            function _lazygit_toggle()
              lazygit:toggle()
            end

            vim.api.nvim_set_keymap("n", "<leader>gsl", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true, desc = "lazygit"})
        end,
    },
    -- Misc
    {
        'mbbill/undotree',
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "undotree toggle" },
        },
    },
    {
        "gbprod/yanky.nvim",
        -- event = "VeryLazy", 
        config = function()
            require("yanky").setup({
                highlight = {
                    timer = 200,
                },
            })
            vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
            -- Convert to lua

            vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
            vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
            vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

            vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
            vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
        end,
    },
    {
        'Wansmer/treesj',
        opts = {
            use_default_keymaps = false,
        },
        keys = {
            { "<space>J", "<cmd>lua require('treesj').toggle()<cr>", desc = "toggle code join" },
            -- { "<space>Jm", "<cmd>lua require('treesj').join()<cr>", desc = "code join" },
            -- { "<space>Js", "<cmd>lua require('treesj').split()<cr>", desc = "code split" }
        },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    {
        "folke/zen-mode.nvim",
        keys = {
            { "<leader>zz", "<cmd>lua require('zen-mode').toggle({ window = { width = .85 }})<cr>", desc = "zen mode" },
        },
    },
    {
        'vladdoster/remember.nvim',
        config = function()
            require("remember").setup({})
        end,
    },
    {
        "sitiom/nvim-numbertoggle",
    },
    {
        'glepnir/dbsession.nvim',
        keys = {
            { "<leader>ws", "<cmd>SessionSave<cr>", desc = "save session" },
            { "<leader>wx", "<cmd>SessionDelete<cr>", desc = "delete session" },
            { "<leader>wl", "<cmd>SessionLoad<cr>", desc = "load session" },
        },
        opts = {}
    },
    {
        "smjonas/inc-rename.nvim",
        keys = {
            { "<leader>rn", "<cmd>lua require('inc_rename').rename()<cr>", desc = "rename" },
        },
        config = function()
            require("inc_rename").setup()
        end,
    },
    {
        "monaqa/dial.nvim",
        keys = {
            { "<C-a>", "<cmd>lua require('dial.map').manipulate('increment', 'normal')<cr>", desc = "increment" },
            { "<C-x>", "<cmd>lua require('dial.map').manipulate('decrement', 'normal')<cr>", desc = "decrement" },
        },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
              default = {
                augend.integer.alias.decimal,
                augend.integer.alias.hex,
                augend.semver.alias.semver,
                augend.date.alias["%Y/%m/%d"],
              },
            })
        end,
    }

}
