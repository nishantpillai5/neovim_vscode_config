local M = {}

M.keys = {
  { '<leader>gB', desc = 'blame_buffer' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>gB', function()
    vim.cmd 'Gitsigns blame'
  end)
end

M.setup = function()
  local gitsigns = require 'gitsigns'
  gitsigns.setup {
    current_line_blame_opts = {
      delay = 100,
    },
    on_attach = function(bufnr)
      -- vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { desc = 'blame' })

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
      end, { desc = 'hunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'hunk' })

      -- Actions
      map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'stage' })
      map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'reset' })
      map('v', '<leader>ghs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'stage' })
      map('v', '<leader>ghr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'reset' })
      map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'stage_buffer' })
      map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = 'undo_stage' })
      map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'reset_buffer' })
      map('n', '<leader>ghd', gitsigns.preview_hunk, { desc = 'diff' })
      map('n', '<leader>ghb', function()
        gitsigns.blame_line { full = true }
      end, { desc = 'blame' })
      map('n', '<leader>gV', gitsigns.toggle_deleted, { desc = 'virtual_deleted' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      -- Addon
      require('scrollbar.handlers.gitsigns').setup()
    end,
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
