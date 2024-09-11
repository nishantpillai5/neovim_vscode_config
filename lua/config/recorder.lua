local M = {}

M.keys = {
  { 'q', desc = 'macro_record' },
  { 'cq', desc = 'macro' },
  { 'dq', desc = 'macro' },
  { 'yq', desc = 'macro' },
  { 'Q', desc = 'macro_play' },
  { '<leader>q', desc = 'switch_macro_slot' },
}

M.lualine = function()
  local lualineY = require('lualine').get_config().tabline.lualine_y or {}
  table.insert(lualineY, 1, { require('recorder').recordingStatus })
  table.insert(lualineY, 1, { require('recorder').displaySlots })

  require('lualine').setup { tabline = { lualine_y = lualineY } }
end

M.setup = function()
  require('recorder').setup {
    slots = { 'q', 'w', 'e' },
    -- dapSharedKeymaps = true,
    lessNotifications = true,
    logLevel = vim.log.levels.DEBUG,
    mapping = {
      addBreakPoint = '<Nop>',
      switchSlot = '<leader>q',
    },
  }
end

M.config = function()
  M.setup()
  if not vim.g.vscode then
    M.lualine()
  end
end

-- M.config()

return M
