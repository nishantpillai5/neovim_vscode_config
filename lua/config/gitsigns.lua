local M = {}

M.keys = {
  { '<leader>gB', desc = 'blame_buffer' },
  { '[c', desc = 'prev_hunk' },
  { ']c', desc = 'next_hunk' },
  { '<leader>ghs', desc = 'stage' },
  { '<leader>ghr', desc = 'reset' },
  { '<leader>ghS', desc = 'stage_buffer' },
  { '<leader>ghu', desc = 'undo_stage' },
  { '<leader>ghR', desc = 'reset_buffer' },
  { '<leader>gRj', desc = 'reset_file' },
  { '<leader>ghd', desc = 'diff' },
  { '<leader>ghb', desc = 'blame' },
  { '<leader>gV', desc = 'virtual_deleted' },
  { 'ih', mode = { 'o', 'x' }, desc = 'select_hunk' },
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
      local set_keymap = require('common.utils').get_keymap_setter(M.keys, { buffer = bufnr })

      -- Navigation
      set_keymap('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'hunk' })

      set_keymap('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'hunk' })

      -- Actions
      set_keymap('n', '<leader>ghs', gitsigns.stage_hunk)
      set_keymap('n', '<leader>ghr', gitsigns.reset_hunk)
      set_keymap('v', '<leader>ghs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end)
      set_keymap('v', '<leader>ghr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end)
      set_keymap('n', '<leader>ghS', gitsigns.stage_buffer)
      set_keymap('n', '<leader>ghu', gitsigns.undo_stage_hunk)
      set_keymap('n', '<leader>ghR', gitsigns.reset_buffer)
      set_keymap('n', '<leader>gRj', gitsigns.reset_buffer)
      set_keymap('n', '<leader>ghd', gitsigns.preview_hunk)
      set_keymap('n', '<leader>ghb', function()
        gitsigns.blame_line { full = true }
      end)
      set_keymap('n', '<leader>gV', gitsigns.toggle_deleted)

      -- Text object
      set_keymap({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
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
