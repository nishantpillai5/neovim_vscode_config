local M = {}

M.setup = function()
  local gitsigns = require 'gitsigns'
  gitsigns.setup {
    current_line_blame_opts = {
      delay = 300,
    },
    current_line_blame_formatter_opts = {
      relative_time = true,
    },
    on_attach = function(bufnr)
      vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { desc = 'Git.blame' })

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Next.chunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Prev.chunk' })

      -- Actions
      map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Git.Hunk.stage' })
      map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Git.Hunk.reset' })
      map('v', '<leader>ghs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Git.Hunk.stage' })
      map('v', '<leader>ghr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Git.Hunk.reset' })
      map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'Git.Hunk.stage_buffer' })
      map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = 'Git.Hunk.undo_stage' })
      map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'Git.Hunk.reset_buffer' })
      map('n', '<leader>ghd', gitsigns.preview_hunk, { desc = 'Git.Hunk.diff' })
      map('n', '<leader>ghb', function()
        gitsigns.blame_line { full = true }
      end, { desc = 'Git.Hunk.blame' })
      map('n', '<leader>gf', gitsigns.diffthis, { desc = 'Git.file_diff' })
      map('n', '<leader>zgd', gitsigns.toggle_deleted, { desc = 'Visual.Git.deleted' })
      map('n', '<leader>zgb', gitsigns.toggle_current_line_blame, { desc = 'Visual.Git.blame' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      -- Addon
      require('scrollbar.handlers.gitsigns').setup()
    end,
  }
end

return M
