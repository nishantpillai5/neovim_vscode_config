local M = {}

M.keys = {
  { 'mm', desc = 'mark' },
  { '<leader>wm', desc = 'load_marks' },
  { 'md', desc = 'delete_in_buffer' },
  { 'mD', desc = 'delete_all' },
  { 'mn', desc = 'nearest' },
  { 'mp', desc = 'paste_last' },
  { 'mP', desc = 'paste_all' },
  { 'mx', desc = 'back' },
  { '<leader>m', desc = 'toggle_trail_mark_list' },
  { '<C-PageDown>', desc = 'next_mark' },
  { '<C-PageUp>', desc = 'previous_mark' },
}

M.mark_at_pos = function()
  local common = require 'trailblazer.trails.common'
  local actions = require 'trailblazer.trails.actions'
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(win)
  actions.new_trail_mark(win, buf, pos)

  local line = vim.fn.getline '.'
  for i = 0, #line - 1 do
    if i ~= pos[2] then
      common.delete_trail_mark_at_pos(win, buf, { pos[1], i })
    end
  end
end

M.keymaps = function()
  local actions = require 'trailblazer.trails.actions'

  local motions = require 'trailblazer.trails.motions'
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', 'md', function()
    actions.delete_all_trail_marks(vim.api.nvim_get_current_buf())
  end)

  set_keymap('n', 'mm', function()
    M.mark_at_pos()
  end)

  set_keymap('n', '<leader>wm', '<cmd>TrailBlazerLoadSession<cr>')

  set_keymap('n', '<C-PageDown>', function()
    motions.peek_move_next_down()
    vim.cmd 'normal! zz'
  end)
  set_keymap('n', '<C-PageUp>', function()
    motions.peek_move_previous_up()
    vim.cmd 'normal! zz'
  end)
end

M.setup = function()
  require('trailblazer').setup {
    auto_save_trailblazer_state_on_exit = true,
    -- auto_load_trailblazer_state_on_enter = true,
    trail_options = {
      current_trail_mark_mode = 'buffer_local_line_sorted',
      multiple_mark_symbol_counters_enabled = false,
      trail_mark_in_text_highlights_enabled = true,
      mark_symbol = '',
      newest_mark_symbol = '',
      cursor_mark_symbol = '',
      next_mark_symbol = '',
      previous_mark_symbol = '',
    },
    force_mappings = {
      nv = {
        motions = {
          track_back = 'mx',
          move_to_nearest = 'mn',
          toggle_trail_mark_list = '<leader>m',
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
