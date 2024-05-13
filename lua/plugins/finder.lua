local plugins = {
  "nvim-telescope/telescope.nvim",
  "OliverChao/telescope-picker-list.nvim",
  "ThePrimeagen/harpoon",
  "nvim-pack/nvim-spectre",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "nvim-telescope/telescope.nvim",
    cond = conds["nvim-telescope/telescope.nvim"] or false,
    event = "VeryLazy",
    keys = {
      { "<leader>ff", desc = "Find.git_files" },
      { "<leader>fa", desc = "Find.all" },
      { "<leader>fgs", desc = "Find.Git.status" },
      { "<leader>fgb", desc = "Find.Git.branch" },
      { "<leader>fgc", desc = "Find.Git.commits" },
      { "<leader>fgz", desc = "Find.Git.stash" },
      { "<leader>fl", desc = "Find.Live_grep.global" },
      { "<leader>fL", desc = "Find.Live_grep.global_with_args" },
      { "<leader>f/", desc = "Find.Search.in_buffers" },
      { "<leader>f?", desc = "Find.Search.global" },
      { "<leader>fw", desc = "Find.word" },
      { "<leader>fW", desc = "Find.whole_word" },
      { "<leader>fo", desc = "Find.symbols" },
      { "<leader>fm", desc = "Find.marks" },
      { "<leader>fr", desc = "Find.registers" },
      -- { "<leader>fp", desc = "Find.yank" },
      { "<leader>fb", desc = "Find.buffers" },
      { "<leader>fn", desc = "Find.notes" },
      { "<leader>F", desc = "Find.telescope" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "natecraddock/telescope-zf-native.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
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

      _G.loaded_telescope_extension = false
      require("telescope").load_extension("zf-native")

      -- Keymaps
      _G.Telescope_keymaps = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.git_files, { desc = "Find.git_files" })
        vim.keymap.set("n", "<leader>fa", builtin.find_files, { desc = "Find.all" })

        vim.keymap.set("n", "<leader>fgs", builtin.git_status, { desc = "Find.Git.status" })
        vim.keymap.set("n", "<leader>fgb", builtin.git_branches, { desc = "Find.Git.branches" })
        vim.keymap.set("n", "<leader>fgc", builtin.git_bcommits, { desc = "Find.Git.commits" })
        vim.keymap.set("n", "<leader>fgz", builtin.git_stash, { desc = "Find.Git.stash" })

        vim.keymap.set("n", "<leader>fl", builtin.live_grep, { desc = "Find.Live_grep.global" })
        vim.keymap.set(
          "n",
          "<leader>fL",
          "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
          { desc = "Find.Live_grep.global_with_args" }
        )

        vim.keymap.set("n", "<leader>f/", function()
          builtin.grep_string({
            search = vim.fn.input("Search > "),
            grep_open_files = true,
          })
        end, { desc = "Find.Search.in_buffers" })

        vim.keymap.set("n", "<leader>f?", function()
          builtin.grep_string({ search = vim.fn.input("Search > ") })
        end, { desc = "Find.Search.global" })

        vim.keymap.set("n", "<leader>fw", function()
          local word = vim.fn.expand("<cword>")
          builtin.grep_string({ search = word })
        end, { desc = "Find.word" })

        vim.keymap.set("n", "<leader>fW", function()
          local word = vim.fn.expand("<cWORD>")
          builtin.grep_string({ search = word })
        end, { desc = "Find.whole_word" })

        vim.keymap.set("n", "<leader>F", "<cmd>Telescope<cr>", { desc = "Find.telescope" })

        vim.keymap.set("n", "<leader>fo", builtin.lsp_document_symbols, { desc = "Find.symbols" })
        vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Find.marks" })
        vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "Find.registers" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find.buffers" })
        -- vim.keymap.set("n", "<leader>fp", "<cmd>Telescope yank_history<cr>")
        -- TODO: use string instead to prevent loading extensions?
        -- vim.keymap.set({ "n", "x" }, "<leader>rr", function()
        --   require("telescope").extensions.refactoring.refactors()
        -- end)

        vim.keymap.set( "n", "<leader>fn", function ()
            builtin.find_files({
              cwd = require("common.env").DIR_NOTES
            })
        end, { desc = "Find.notes" })


      end

      _G.Telescope_keymaps()
    end,
  },
  {
    "OliverChao/telescope-picker-list.nvim",
    cond = conds["OliverChao/telescope-picker-list.nvim"] or false,
    dependencies = {
      "Snikimonkd/telescope-git-conflicts.nvim",
    },
    keys = {
      {
        "<leader>ft",
          function ()
            if not _G.loaded_telescope_extension then
              require("telescope").load_extension("conflicts")
              -- require("telescope").load_extension("yank_history")
              -- require("telescope").load_extension("refactoring")
              require("telescope").load_extension("notify")
              require("telescope").load_extension("picker_list")
              _G.loaded_telescope_extension = true
            end
            require("telescope").extensions.picker_list.picker_list()
          end,
        mode = "n",
        desc = "Find.telescope"
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    cond = conds["ThePrimeagen/harpoon"] or false,
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
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

      -- Telescope
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

      -- Keymaps
      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end, { desc = "harpoon_add" })
      vim.keymap.set("n", "<leader>h", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "harpoon_list" })
      vim.keymap.set("n", "<leader>fh", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Find.harpoon" })
      vim.keymap.set("n", "<C-PageUp>", function()
        harpoon:list():prev()
      end, { desc = "harpoon_prev" })
      vim.keymap.set("n", "<C-PageDown>", function()
        harpoon:list():next()
      end, { desc = "harpoon_next" })

      -- Lualine
      local function lualine_indicator(harpoon_entry)
        local harpoon_file_path = harpoon_entry.value
        local file_name = harpoon_file_path == "" and "(empty)" or vim.fn.fnamemodify(harpoon_file_path, ":t")
        return file_name
      end

      local tablineA = require("lualine").get_config().tabline.lualine_a or {}
      local lualineC = require("lualine").get_config().sections.lualine_c or {}
      table.insert(tablineA, {
          "harpoon2",
          _separator = " | ",
          indicators = { "1", "2", "3", "4" },
          active_indicators = {
            lualine_indicator,
            lualine_indicator,
            lualine_indicator,
            lualine_indicator,
          },
      })
      table.insert(lualineC, 1, { "harpoon2" })

      require("lualine").setup {
        sections = { lualine_c = lualineC},
        tabline = { lualine_a = tablineA },
      }
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    cond = conds["nvim-pack/nvim-spectre"] or false,
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
}
