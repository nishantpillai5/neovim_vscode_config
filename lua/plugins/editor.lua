local plugins = {
  -- Autoclose
  "windwp/nvim-autopairs",
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
  -- "gbprod/yanky.nvim", -- WARN: irresponsive when switching into terminal
  "Wansmer/treesj",
  "folke/zen-mode.nvim",
  -- "shortcuts/no-neck-pain.nvim", --TODO: Split doesn't work
  "vladdoster/remember.nvim",
  -- "sitiom/nvim-numbertoggle", -- WARN: doesn't work with harpoon
  "RRethy/vim-illuminate",
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
      local config = require("config.todo_comments")
      config.setup()
      config.keymaps()
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
      vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateNext)
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
      window = {
        width = .85,
      },
      plugins = {
        options = { enabled = true, laststatus = 3 },
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
}
