return {
  -- Comments
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  -- Tmux like navigation
  {
    "alexghergh/nvim-tmux-navigation",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")
      nvim_tmux_nav.setup({
        disable_when_zoomed = true, -- defaults to false
      })

      vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
  -- Git
  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>gss", "<cmd>Git<cr>", desc = "Gitstatus.fugitive" },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gsl", "<cmd>LazyGit<cr>", desc = "Gitstatus.lazygit" },
    },
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, { desc = "Next.chunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, { desc = "Prev.chunk" })

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
        end,
      })
    end,
  },
  -- Finder
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ff", desc = "Find.git" },
      { "<leader>fa", desc = "Find.all" },
      { "<leader>fg", desc = "Find.Grep.buffers/workspace" },
      { "<leader>fgg", desc = "Find.Grep.global" },
      { "<leader>f/", desc = "Find.Search" },
      { "<leader>f/w", desc = "Find.Search.word" },
      { "<leader>f/W", desc = "Find.Search.whole_word" },
      { "<leader>fo", desc = "Find.symbols" },
      { "<leader>fm", desc = "Find.marks" },
      { "<leader>fr", desc = "Find.registers" },
      { "<leader>fp", desc = "Find.yank" },
      { "<leader>fb", desc = "Find.buffers" },
      { "<leader>ft", desc = "Find.telescope" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "natecraddock/telescope-zf-native.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "Snikimonkd/telescope-git-conflicts.nvim",
      "OliverChao/telescope-picker-list.nvim",
    },
    config = function()
      local lga_actions = require("telescope-live-grep-args.actions")
      require("telescope").setup({
        defaults = {
          path_display = {
            filename_first = { reverse_directories = true },
          },
        },
        pickers = {
          find_files = { follow = true },
          live_grep = { follow = true },
          grep_string = { follow = true },
        },
        extensions = {
          ["zf-native"] = {
            file = {
              enable = true,
              highlight_results = true,
              match_filename = true,
              initial_sort = nil,
              smart_case = true,
            },
            generic = {
              enable = true,
              highlight_results = true,
              match_filename = false,
              initial_sort = nil,
              smart_case = true,
            },
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
        },
      })

      require("telescope").load_extension("zf-native")
      require("telescope").load_extension("conflicts")
      require("telescope").load_extension("yank_history")
      require("telescope").load_extension("picker_list")

      -- Keymaps
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.git_files)
      vim.keymap.set("n", "<leader>fa", builtin.find_files)
      vim.keymap.set("n", "<leader>fgg", builtin.live_grep)
      -- vim.keymap.set("n", "<leader>fgg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>")

      vim.keymap.set("n", "<leader>fg", function()
        builtin.live_grep({ grep_open_files = true })
      end)
      vim.keymap.set("n", "<leader>f/", function()
        builtin.grep_string({ search = vim.fn.input("Search > ") })
      end)
      vim.keymap.set("n", "<leader>f/w", function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = word })
      end)
      vim.keymap.set("n", "<leader>f/W", function()
        local word = vim.fn.expand("<cWORD>")
        builtin.grep_string({ search = word })
      end)
      vim.keymap.set("n", "<leader>fo", builtin.lsp_document_symbols)
      vim.keymap.set("n", "<leader>fm", builtin.marks)
      vim.keymap.set("n", "<leader>fr", builtin.registers, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
      -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

      vim.keymap.set("n", "<leader>fp", "<cmd>Telescope yank_history<cr>")
      vim.keymap.set("n", "<leader>ft", require("telescope").extensions.picker_list.picker_list)
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>a", desc = "harpoon_add" },
      { "<leader>h", desc = "harpoon_list" },
      { "<leader>fh", desc = "Find.harpoon" },
      { "<C-PageUp>", desc = "harpoon_prev" },
      { "<C-PageDown>", desc = "harpoon_next" },
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

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end)
      vim.keymap.set("n", "<leader>h", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
      vim.keymap.set("n", "<leader>fh", function()
        toggle_telescope(harpoon:list())
      end)
      vim.keymap.set("n", "<C-PageUp>", function()
        harpoon:list():prev()
      end)
      vim.keymap.set("n", "<C-PageDown>", function()
        harpoon:list():next()
      end)
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    keys = {
      {
        "<leader>//",
        "<cmd>lua require('spectre').open_file_search()<cr>",
        mode = "n",
        desc = "Search.local",
      },
      {
        "<leader>//",
        "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>",
        mode = "v",
        desc = "Search.local",
      },
      { "<leader>/", "<cmd>lua require('spectre').toggle()<cr>", desc = "Search.global" },
      {
        "<leader>/w",
        "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
        mode = "n",
        desc = "Search.global.word",
      },
      { "<leader>/w", "<cmd>lua require('spectre').open_visual()<cr>", mode = "v", desc = "Search.global.word" },
    },
  },
  -- Explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>ee", "<cmd>Neotree reveal focus toggle<cr>", desc = "Explorer.neotree" },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>eee", "<cmd>Oil<cr>", desc = "Explorer.oil" },
    },
    config = function()
      require("oil").setup({
        -- Keep netrw enabled
        default_file_explorer = false,
      })
    end,
  },
  {
    "liuchengxu/vista.vim",
    keys = {
      { "<leader>eo", "<cmd>Vista!!<cr>", mode = "n", desc = "Explorer.symbols" },
    },
    config = function()
      vim.g.vista_echo_cursor_strategy = "floating_win"
      vim.g.vista_sidebar_position = "vertical topleft"
    end,
  },
  -- Panel
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>tt", "<cmd>lua require('trouble').toggle()<cr>", desc = "Trouble.toggle" },
      {
        "<leader>tw",
        "<cmd>lua require('trouble').toggle('workspace_diagnostics')<cr>",
        desc = "Trouble.workspace_diagnostics",
      },
      {
        "<leader>td",
        "<cmd>lua require('trouble').toggle('document_diagnostics')<cr>",
        desc = "Trouble.document_diagnostics",
      },
      { "<leader>tq", "<cmd>lua require('trouble').toggle('quickfix')<cr>", desc = "Trouble.quickfix" },
      { "<leader>tl", "<cmd>lua require('trouble').toggle('loclist')<cr>", desc = "Trouble.loclist" },
      {
        "<leader>]t",
        "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>",
        desc = "Next.trouble",
      },
      {
        "<leader>[t",
        "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>",
        desc = "Previous.trouble",
      },
      -- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
    },
  },
  -- Terminal
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>f;", "<cmd>Telescope toggleterm_manager<cr>", desc = "Find.terminal" },
      { "<leader>;;", "<cmd>lua require('toggleterm').toggle_all(true)<cr>", desc = "Terminal.toggle" },
    },
    config = function()
      local toggleterm_manager = require("toggleterm-manager")
      local actions = toggleterm_manager.actions
      toggleterm_manager.setup({
        mappings = {
          n = {
            ["<CR>"] = { action = actions.toggle_term, exit_on_action = true },
            ["o"] = { action = actions.create_and_name_term, exit_on_action = true },
            ["i"] = { action = actions.create_term, exit_on_action = true },
            ["x"] = { action = actions.delete_term, exit_on_action = false },
          },
        },
      })
    end,
  },
  -- Misc
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "undotree_toggle" },
    },
  },
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    config = function()
      require("yanky").setup({
        highlight = {
          timer = 200,
        },
      })
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      -- Convert to lua

      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

      vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
    end,
  },
  {
    "Wansmer/treesj",
    opts = {
      use_default_keymaps = false,
    },
    keys = {
      { "<space>J", "<cmd>lua require('treesj').toggle()<cr>", desc = "code_join" },
      -- { "<space>Jm", "<cmd>lua require('treesj').join()<cr>", desc = "code join" },
      -- { "<space>Js", "<cmd>lua require('treesj').split()<cr>", desc = "code split" }
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>zz", "<cmd>lua require('zen-mode').toggle({ window = { width = .85 }})<cr>", desc = "Visual.zen" },
    },
  },
  {
    "vladdoster/remember.nvim",
    event = "VeryLazy",
    config = function()
      require("remember").setup({})
    end,
  },
  {
    "sitiom/nvim-numbertoggle",
    event = { "BufReadPre", "BufNewFile" },
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
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        keywords = { NISH = { icon = "󰬕", color = "info" } },
      })

      vim.keymap.set("n", "]d", function()
        require("todo-comments").jump_next()
      end, { desc = "Next.todo" })

      vim.keymap.set("n", "[d", function()
        require("todo-comments").jump_prev()
      end, { desc = "Prev.todo" })
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "chentoast/marks.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
