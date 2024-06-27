local M = {}

M.keymaps = function()
  local common = require('trailblazer.trails.common')

  vim.keymap.set('n', 'md', function ()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    local pos = vim.api.nvim_win_get_cursor(win)
    common.delete_trail_mark_at_pos(win, buf, pos)
  end, { desc='delete' })
end

M.setup = function()
  require('trailblazer').setup {
    trail_options = {
      current_trail_mark_mode = "global_buf_line_sorted",
      multiple_mark_symbol_counters_enabled = false,
      trail_mark_in_text_highlights_enabled = false,
      mark_symbol = "",
      newest_mark_symbol = "",
      cursor_mark_symbol = "",
      next_mark_symbol = "",
      previous_mark_symbol = "",
    },
    force_mappings = {
      nv = {
        motions = {
          new_trail_mark = 'mm',
          track_back = 'mb',
          peek_move_next_down = '<A-PageDown>',
          peek_move_previous_up = '<A-PageUp>',
          move_to_nearest = 'mn',
          toggle_trail_mark_list = 'M',
        },
        actions = {
          delete_all_trail_marks = 'mD',
          paste_at_last_trail_mark = 'mp',
          paste_at_all_trail_marks = 'mP',
        },
      },
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
