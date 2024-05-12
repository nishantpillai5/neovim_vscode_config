local plugins = {
  -- Autoclose
  "windwp/nvim-autopairs",
  -- Inline macro
  "AllenDang/nvim-expand-expr",
  -- Macros
  "chrisgrieser/nvim-recorder",
  -- Comments
  "numToStr/Comment.nvim",
  "folke/todo-comments.nvim",
  -- Tmux like navigation
  "alexghergh/nvim-tmux-navigation",
  -- Refactor
  "smjonas/inc-rename.nvim",
  -- "ThePrimeagen/refactoring.nvim", -- WARN: not tested, slow startup
  -- Misc
  "mbbill/undotree",
  "gbprod/yanky.nvim", -- WARN: This slows things down
  "monaqa/dial.nvim",
  "chentoast/marks.nvim",
  "Wansmer/treesj",
  "folke/zen-mode.nvim",
  -- "shortcuts/no-neck-pain.nvim", --TODO: Split doesn't work
  "vladdoster/remember.nvim",
  "sitiom/nvim-numbertoggle",
  "RRethy/vim-illuminate",
  "gregorias/coerce.nvim",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  -- Autoclose
  {
    "windwp/nvim-autopairs",
    cond = conds["windwp/nvim-autopairs"] or false,
    event = "InsertEnter",
    config = true,
  },
  -- Inline macro
  {
    "AllenDang/nvim-expand-expr",
    cond = conds["AllenDang/nvim-expand-expr"] or false,
    keys = {
      { "<leader>oq", function() require("expand_expr").expand() end, desc = "Tasks.inline_macro" },
    },
  },
  -- Macros
  {
    "chrisgrieser/nvim-recorder",
    cond = conds["chrisgrieser/nvim-recorder"] or false,
    keys = {
      { "q", desc = "macro_record" },
      { "Q", desc = "macro_play" },
	},
    config = function ()
      require("recorder").setup({
        -- dapSharedKeymaps = true,
        lessNotifications = true,
        logLevel = vim.log.levels.DEBUG,
        mapping = {
          addBreakPoint = "|NX2J0CdIE",
        },
      })
      local lualineY = require("lualine").get_config().tabline.lualine_y or {}
      table.insert(lualineY, { require("recorder").recordingStatus })
      table.insert(lualineY, { require("recorder").displaySlots })

      require("lualine").setup {
        tabline = { lualine_y = lualineY },
      }
    end
  },
  -- Comments
  {
    "numToStr/Comment.nvim",
    cond = conds["numToStr/Comment.nvim"] or false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    cond = conds["folke/todo-comments.nvim"] or false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        keywords = { NISH = { icon = "󰬕", color = "info" } },
      })

      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next.todo" })

      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Prev.todo" })
    end,
  },
  -- Tmux like navigation
  {
    "alexghergh/nvim-tmux-navigation",
    cond = conds["alexghergh/nvim-tmux-navigation"] or false,
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
  -- Refactor
  {
    "smjonas/inc-rename.nvim",
    cond = conds["smjonas/inc-rename.nvim"] or false,
    keys = {
      { "<leader>rn", desc = "Refactor.rename" },
    },
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true })
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    cond = conds["ThePrimeagen/refactoring.nvim"] or false,
    keys = {
      { "<leader>rr", desc = "Refactor.refactor" },
    },
    opts = {},
  },
  -- Misc
  {
    "mbbill/undotree",
    cond = conds["mbbill/undotree"] or false,
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "undotree_toggle" },
    },
  },
  {
    "gbprod/yanky.nvim",
    cond = conds["gbprod/yanky.nvim"] or false,
    event = "VeryLazy",
    config = function()
      require("yanky").setup({
        highlight = {
          timer = 200,
        },
      })
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

      vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
    end,
  },
  {
    "monaqa/dial.nvim",
    cond = conds["monaqa/dial.nvim"] or false,
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
    "chentoast/marks.nvim",
    cond = conds["chentoast/marks.nvim"] or false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "Wansmer/treesj",
    cond = conds["Wansmer/treesj"] or false,
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
    cond = conds["folke/zen-mode.nvim"] or false,
    keys = {
      { "<leader>zz", "<cmd>lua require('zen-mode').toggle()<cr>", desc = "Visual.zen" },
    },
    opts = {
      windows = {
        width = .85,
      },
      plugins = {
        gitsigns = { enabled = false },
      },
    },
  },
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    cond = conds["shortcuts/no-neck-pain.nvim"] or false,
    keys = {
      { "<leader>zz", ":NoNeckPain<cr>", desc = "Visual.zen", silent = true },
    },
  },
  {
    "vladdoster/remember.nvim",
    cond = conds["vladdoster/remember.nvim"] or false,
    event = "VeryLazy",
    config = function()
      require("remember").setup({})
    end,
  },
  {
    "sitiom/nvim-numbertoggle",
    cond = conds["sitiom/nvim-numbertoggle"] or false,
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "RRethy/vim-illuminate",
    cond = conds["RRethy/vim-illuminate"] or false,
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "gregorias/coerce.nvim",
    cond = conds["gregorias/coerce.nvim"] or false,
    keys = {
      { "cr", desc = "coerce" },
    },
    tag = "v1.0",
    opts = {},
  },
}
