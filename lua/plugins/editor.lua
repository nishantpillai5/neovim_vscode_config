local load_plugin = {}
-- Comments
load_plugin["numToStr/Comment.nvim"] = true
load_plugin["folke/todo-comments.nvim"] = true
-- Tmux like navigation
load_plugin["alexghergh/nvim-tmux-navigation"] = true
-- Refactor
load_plugin["smjonas/inc-rename.nvim"] = true
load_plugin["ThePrimeagen/refactoring.nvim"] = false -- WARN: not tested, slow startup
-- Misc
load_plugin["mbbill/undotree"] = true
load_plugin["gbprod/yanky.nvim"] = false -- WARN: This slows things down
load_plugin["monaqa/dial.nvim"] = true
load_plugin["chentoast/marks.nvim"] = true
load_plugin["Wansmer/treesj"] = true
load_plugin["folke/zen-mode.nvim"] = true
load_plugin["vladdoster/remember.nvim"] = true
load_plugin["sitiom/nvim-numbertoggle"] = true
load_plugin["RRethy/vim-illuminate"] = true

return {
  -- Comments
  {
    "numToStr/Comment.nvim",
    cond = load_plugin["numToStr/Comment.nvim"],
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    cond = load_plugin["folke/todo-comments.nvim"],
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
    cond = load_plugin["alexghergh/nvim-tmux-navigation"],
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
    cond = load_plugin["smjonas/inc-rename.nvim"],
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
    cond = load_plugin["ThePrimeagen/refactoring.nvim"],
    keys = {
      { "<leader>rr", desc = "Refactor.refactor" },
    },
    opts = {},
  },
  -- Misc
  {
    "mbbill/undotree",
    cond = load_plugin["mbbill/undotree"],
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "undotree_toggle" },
    },
  },
  {
    "gbprod/yanky.nvim",
    cond = load_plugin["gbprod/yanky.nvim"],
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
    cond = load_plugin["monaqa/dial.nvim"],
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
    cond = load_plugin["chentoast/marks.nvim"],
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "Wansmer/treesj",
    cond = load_plugin["Wansmer/treesj"],
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
    cond = load_plugin["folke/zen-mode.nvim"],
    keys = {
      { "<leader>zz", "<cmd>lua require('zen-mode').toggle({ window = { width = .85 }})<cr>", desc = "Visual.zen" },
    },
  },
  {
    "vladdoster/remember.nvim",
    cond = load_plugin["vladdoster/remember.nvim"],
    event = "VeryLazy",
    config = function()
      require("remember").setup({})
    end,
  },
  {
    "sitiom/nvim-numbertoggle",
    cond = load_plugin["sitiom/nvim-numbertoggle"],
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "RRethy/vim-illuminate",
    cond = load_plugin["RRethy/vim-illuminate"],
    event = { "BufReadPre", "BufNewFile" },
  },
}
