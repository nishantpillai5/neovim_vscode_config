local plugins = {
  "tpope/vim-fugitive",
  "kdheepak/lazygit.nvim",
  "lewis6991/gitsigns.nvim",
  "sindrets/diffview.nvim",
}

local cond_table = require("common.lazy").get_cond_table(plugins)
local get_cond = require("common.lazy").get_cond

return {
  {
    "tpope/vim-fugitive",
    cond = get_cond("tpope/vim-fugitive", cond_table),
    event = "VeryLazy",
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git.status" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git.log" },
      { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git.blame_buffer" },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cond = get_cond("kdheepak/lazygit.nvim", cond_table),
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gz", "<cmd>LazyGit<cr>", desc = "Git.lazygit" },
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
    "sindrets/diffview.nvim",
    cond = get_cond("sindrets/diffview.nvim", cond_table),
    keys = {
      { "<leader>gd", desc = "Git.diff" },
    },
    config = function()
      local diffview_toggle = function()
        local lib = require("diffview.lib")
        local view = lib.get_current_view()
        if view then
          vim.cmd.DiffviewClose()
        else
          vim.cmd.DiffviewOpen()
        end
      end

      vim.keymap.set("n", "<leader>gd", diffview_toggle, { desc = "Git.diff" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    cond = get_cond("lewis6991/gitsigns.nvim", cond_table),
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")
          vim.keymap.set("n", "<leader>gb", require("gitsigns").blame_line, { desc = "Git.blame" })

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
          map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Git.Hunk.stage" })
          map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Git.Hunk.reset" })
          map("v", "<leader>ghs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Git.Hunk.stage" })
          map("v", "<leader>ghr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Git.Hunk.reset" })
          map("n", "<leader>ghS", gitsigns.stage_buffer, { desc = "Git.Buffer.stage_buffer" })
          map("n", "<leader>ghu", gitsigns.undo_stage_hunk, { desc = "Git.Hunk.undo_stage" })
          map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "Git.Hunk.reset_buffer" })
          map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "Git.Hunk.preview" })
          map("n", "<leader>ghb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Git.Hunk.blame" })
          map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Git.toggle.blame" })
          map("n", "<leader>ghd", gitsigns.diffthis, { desc = "Git.Hunk.diff1" })
          map("n", "<leader>ghD", function()
            gitsigns.diffthis("~")
          end, { desc = "Git.Hunk.diff2" })
          map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "Git.toggle.deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
          -- Addon
          require("scrollbar.handlers.gitsigns").setup()
        end,
      })
    end,
  },
}
