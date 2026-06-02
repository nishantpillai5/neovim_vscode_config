local M = {}

M.keys = {
  { '<leader>ns', mode = { 'n', 'i', 'v' }, desc = 'stt' },
}

M.setup = function()
  require('whisper').setup {
    model = 'medium.en',
    keybind = '<leader>ns',
    manual_trigger_key = '<Tab>',
    filter_markers = false,
  }
end

M.lualine = function()
  local lualineY = require('lualine').get_config().tabline.lualine_y or {}
  local index = #lualineY == 0 and 1 or #lualineY
  table.insert(lualineY, index, { require('whisper').lualine_component })

  require('lualine').setup { tabline = { lualine_y = lualineY } }
end

M.config = function()
  M.setup()
  M.lualine()
end

-- M.config()

return M
