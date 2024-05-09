local plugins = {
  "nvim-telescope/telescope.nvim",
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
      { "<leader>fn", desc = "Find.notes" },
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
      -- require("telescope").load_extension("refactoring")
      require("telescope").load_extension("notify")
      require("telescope").load_extension("picker_list")

      -- Keymaps
      _G.Telescope_keymaps = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.git_files, { desc = "Find.git" })
        vim.keymap.set("n", "<leader>fa", builtin.find_files, { desc = "Find.all" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find.Live_grep.global" })
        vim.keymap.set(
          "n",
          "<leader>fG",
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

        vim.keymap.set("n", "<leader>fo", builtin.lsp_document_symbols, { desc = "Find.symbols" })
        vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Find.marks" })
        vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "Find.registers" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find.buffers" })
        -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        vim.keymap.set("n", "<leader>fp", "<cmd>Telescope yank_history<cr>")

        vim.keymap.set( "n", "<leader>fn", function ()
            builtin.find_files({
              cwd = require("common.env").NOTES_DIR
            })
        end, { desc = "Find.notes" })

        vim.keymap.set(
          "n",
          "<leader>ft",
          require("telescope").extensions.picker_list.picker_list,
          { desc = "Find.telescope" }
        )

        -- vim.keymap.set({ "n", "x" }, "<leader>rr", function()
        --   require("telescope").extensions.refactoring.refactors()
        -- end)
      end

      _G.Telescope_keymaps()
    end,
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
