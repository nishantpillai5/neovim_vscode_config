local plugins = {
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
  -- "gbprod/yanky.nvim", -- WARN: This slows things down
  "monaqa/dial.nvim",
  "chentoast/marks.nvim",
  "Wansmer/treesj",
  "folke/zen-mode.nvim",
  "vladdoster/remember.nvim",
  "sitiom/nvim-numbertoggle",
  "RRethy/vim-illuminate",
  "gregorias/coerce.nvim",
}

local cond_table = require("common.lazy").get_cond_table(plugins)
local get_cond = require("common.lazy").get_cond

return {
  -- Comments
  {
    "numToStr/Comment.nvim",
    cond = get_cond("numToStr/Comment.nvim", cond_table),
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    cond = get_cond("folke/todo-comments.nvim", cond_table),
    event = "VeryLazy",
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
    cond = get_cond("alexghergh/nvim-tmux-navigation", cond_table),
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
    cond = get_cond("smjonas/inc-rename.nvim", cond_table),
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
    cond = get_cond("ThePrimeagen/refactoring.nvim", cond_table),
    keys = {
      { "<leader>rr", desc = "Refactor.refactor" },
    },
    opts = {},
  },
  -- Misc
  {
    "mbbill/undotree",
    cond = get_cond("mbbill/undotree", cond_table),
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "undotree_toggle" },
    },
  },
  {
    "gbprod/yanky.nvim",
    cond = get_cond("gbprod/yanky.nvim", cond_table),
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
    "monaqa/dial.nvim",
    cond = get_cond("monaqa/dial.nvim", cond_table),
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
    cond = get_cond("chentoast/marks.nvim", cond_table),
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "Wansmer/treesj",
    cond = get_cond("Wansmer/treesj", cond_table),
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
    cond = get_cond("folke/zen-mode.nvim", cond_table),
    keys = {
      { "<leader>zz", "<cmd>lua require('zen-mode').toggle({ window = { width = .85 }})<cr>", desc = "Visual.zen" },
    },
  },
  {
    "vladdoster/remember.nvim",
    cond = get_cond("vladdoster/remember.nvim", cond_table),
    event = "VeryLazy",
    config = function()
      require("remember").setup({})
    end,
  },
  {
    "sitiom/nvim-numbertoggle",
    cond = get_cond("sitiom/nvim-numbertoggle", cond_table),
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "RRethy/vim-illuminate",
    cond = get_cond("RRethy/vim-illuminate", cond_table),
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "gregorias/coerce.nvim",
    cond = get_cond("gregorias/coerce.nvim", cond_table),
    keys = {
      { "cr", desc = "coerce" },
    },
    tag = "v1.0",
    opts = {},
  },
}
