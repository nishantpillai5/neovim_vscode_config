local M = {}

M.cmd = { 'StrudelLaunch' }

M.keys = {
  { '<leader>zm', desc = 'launch' },
}

M.buffer_keys = {
  { '<leader>;q', desc = 'quit' },
  { '<leader>;x', desc = 'toggle' },
  { '<leader><leader>', desc = 'update' },
  { '<leader>;X', desc = 'stop' },
  { '<leader>;s', desc = 'buffer' },
  { '<leader>;S', desc = 'buffer_and_update' },
}

-- Define a function that sets buffer-local keymaps
local function set_strudel_keymaps(bufnr)
  local strudel = require 'strudel'
  local set_keymap_buffer = require('common.utils').get_keymap_setter(M.buffer_keys, { buffer = bufnr })
  set_keymap_buffer('n', '<leader>;q', strudel.quit)
  set_keymap_buffer('n', '<leader>;x', strudel.toggle)
  set_keymap_buffer('n', '<leader><leader>', strudel.update)
  set_keymap_buffer('n', '<leader>;X', strudel.stop)
  set_keymap_buffer('n', '<leader>;s', strudel.set_buffer)
  set_keymap_buffer('n', '<leader>;S', strudel.execute)
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  local strudel = require 'strudel'

  set_keymap('n', '<leader>zm', function()
    strudel.launch()
    if vim.fn.expand '%:e' == 'str' then
      set_strudel_keymaps(0)
    end
  end)

  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.str',
    callback = function(args)
      set_strudel_keymaps(args.buf)
    end,
  })
end

M.setup = function()
  require('strudel').setup {
    start_on_launch = false,
    sync_cursor = false,
    -- ui = {
    --   hide_menu_panel = true,
    --   hide_top_bar = true,
    --   hide_error_display = true,
    --   hide_code_editor = true,
    --   -- Set `hide_code_editor = false` if you want to overlay the code editor
    -- },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
