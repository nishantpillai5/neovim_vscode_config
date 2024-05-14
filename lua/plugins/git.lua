local plugins = {
  "tpope/vim-fugitive",
  "kdheepak/lazygit.nvim",
  "lewis6991/gitsigns.nvim",
  "sindrets/diffview.nvim",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "tpope/vim-fugitive",
    cond = conds["tpope/vim-fugitive"] or false,
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git.status" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git.log" },
      { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git.blame_buffer" },
    },
    config = function()
      local fugitive_augroup = vim.api.nvim_create_augroup("AUGfugitive", {})
      local autocmd = vim.api.nvim_create_autocmd
      autocmd("BufWinEnter", {
        group = fugitive_augroup,
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          vim.keymap.set("n", "<leader>P", function()
            vim.cmd [[ Git push ]]
          end, {buffer = bufnr, remap = false, desc = "Git.push"})

          vim.keymap.set("n", "<leader>p", function()
            vim.cmd [[ Git pull --rebase ]]
          end, {buffer = bufnr, remap = false, desc = "Git.pull"})
        end,
      })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cond = conds["kdheepak/lazygit.nvim"] or false,
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
    cond = conds["sindrets/diffview.nvim"] or false,
    keys = {
      { "<leader>gD", desc = "Git.diff" },
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

      vim.keymap.set("n", "<leader>gD", diffview_toggle, { desc = "Git.diff_global" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    cond = conds["lewis6991/gitsigns.nvim"] or false,
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
          map("n", "<leader>ghS", gitsigns.stage_buffer, { desc = "Git.Hunk.stage_buffer" })
          map("n", "<leader>ghu", gitsigns.undo_stage_hunk, { desc = "Git.Hunk.undo_stage" })
          map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "Git.Hunk.reset_buffer" })
          map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "Git.Hunk.preview" })
          map("n", "<leader>ghb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Git.Hunk.blame" })
          map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git.diff" })
          map("n", "<leader>zgd", gitsigns.toggle_deleted, { desc = "Visual.Git.deleted" })
          map("n", "<leader>zgb", gitsigns.toggle_current_line_blame, { desc = "Visual.Git.blame" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
          -- Addon
          require("scrollbar.handlers.gitsigns").setup()
        end,
      })
    end,
  },
}
