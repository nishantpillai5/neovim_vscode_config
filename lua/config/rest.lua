local M = {}

M.ft = { 'http' }

M.buffer_keys = {
  { '<leader>ii', desc = 'http-run' },
  { '<leader>il', desc = 'http-last' },
  { '<leader>io', desc = 'http-open' },
  { '<leader>iL', desc = 'http-logs' },
  { '<leader>ic', desc = 'http-cookies' },
  { '<leader>ie', desc = 'http-env_show' },
  { '<leader>iE', desc = 'http-env_select' },
}

M.keymaps = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'http',
    callback = function()
      local set_keymap = require('common.utils').get_keymap_setter(M.buffer_keys, { buffer = true })
      set_keymap('n', '<leader>ii', '<cmd>Rest run<cr>')
      set_keymap('n', '<leader>il', '<cmd>Rest last<cr>')
      set_keymap('n', '<leader>io', '<cmd>Rest open<cr>')
      set_keymap('n', '<leader>iL', '<cmd>Rest logs<cr>')
      set_keymap('n', '<leader>ic', '<cmd>Rest cookies<cr>')
      set_keymap('n', '<leader>ie', '<cmd>Rest env show<cr>')
      set_keymap('n', '<leader>iE', '<cmd>Rest env select<cr>')
    end,
  })
end

M.setup = function()
---@diagnostic disable-next-line: inject-field
  vim.g.rest_nvim = {
    ui = {
      winbar = true,
      keybinds = {
        prev = '<A-PageUp>',
        next = '<A-PageDown>',
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
