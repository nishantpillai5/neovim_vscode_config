local M = {}

M.keys = {
  { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'yank_after' },
  { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'yank_before' },
  { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'yank_gput_after' },
  { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'yank_gput_before' },
  { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'yank_prev' },
  { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'yank_next' },
  { '<leader>fp', desc = 'yank' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
  set_keymap({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
  set_keymap({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
  set_keymap({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

  set_keymap('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
  set_keymap('n', '<c-n>', '<Plug>(YankyNextEntry)')
  set_keymap('n', '<leader>fp', '<cmd>Telescope yank_history<cr>')
end

M.setup = function()
  require('yanky').setup {
    highlight = {
      timer = 200,
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
