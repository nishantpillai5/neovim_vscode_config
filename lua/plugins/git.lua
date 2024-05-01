local load_plugin = {}

load_plugin["tpope/vim-fugitive"] = true
load_plugin["kdheepak/lazygit.nvim"] = true
load_plugin["lewis6991/gitsigns.nvim"] = true
return {
  {
    "tpope/vim-fugitive",
    cond = load_plugin["tpope/vim-fugitive"],
    event = "VeryLazy",
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git.status" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git.log" },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cond = load_plugin["kdheepak/lazygit.nvim"],
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
    "lewis6991/gitsigns.nvim",
    cond = load_plugin["lewis6991/gitsigns.nvim"],
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
          -- TODO: stage hunk mapping

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
}
