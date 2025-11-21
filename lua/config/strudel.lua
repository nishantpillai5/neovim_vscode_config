local M = {}

M.cmd = { 'StrudelLaunch' }

M.keys = {
  { '<leader>zm', desc = 'launch' },
}

M.buffer_keys = {
  { '<leader>;q', desc = 'quit' },
  { '<leader>;t', desc = 'toggle' },
  { '<leader>;u', desc = 'update' },
  { '<leader>;s', desc = 'stop' },
  { '<leader>;b', desc = 'buffer' },
  { '<leader>;x', desc = 'buffer_and_update' },
}

-- local function pomodoro_text()
--   local pomo = require 'pomo'
--   local timer = pomo.get_first_to_finish()
--   return '󰄉 ' .. tostring(timer)
-- end
--
-- local function pomodoro_cond()
--   local ok, pomo = pcall(require, 'pomo')
--   if not ok then
--     return false
--   end
--
--   return pomo.get_first_to_finish() ~= nil
-- end

-- M.lualine = function()
--   local lualineY = require('lualine').get_config().tabline.lualine_y or {}
--   table.insert(lualineY, { pomodoro_text, cond = pomodoro_cond })
--   require('lualine').setup { tabline = { lualine_y = lualineY } }
-- end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  local strudel = require 'strudel'

  set_keymap('n', '<leader>zm', strudel.launch)

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'str',
    callback = function()
      local set_keymap_buffer = require('common.utils').get_keymap_setter(M.buffer_keys, { buffer = true })
      set_keymap_buffer('n', '<leader>;q', strudel.quit)
      set_keymap_buffer('n', '<leader>;t', strudel.toggle)
      set_keymap_buffer('n', '<leader>;u', strudel.update)
      set_keymap_buffer('n', '<leader>;s', strudel.stop)
      set_keymap_buffer('n', '<leader>;b', strudel.set_buffer)
      set_keymap_buffer('n', '<leader>;x', strudel.execute)
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
  -- M.lualine()
end

-- M.config()

return M
