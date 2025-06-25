local M = {}

M.cmd = { 'TimerStart', 'TimerRepeat', 'TimerSession' }

M.keys = {
  { '<leader>zps', desc = 'start' },
  { '<leader>zpr', desc = 'resume' },
  { '<leader>zpp', desc = 'pause' },
  { '<leader>zpf', desc = 'find' },
}

local function pomodoro_text()
  local pomo = require 'pomo'
  local timer = pomo.get_first_to_finish()
  return '󰄉 ' .. tostring(timer)
end

local function pomodoro_cond()
  local ok, pomo = pcall(require, 'pomo')
  if not ok then
    return false
  end

  return pomo.get_first_to_finish() ~= nil
end

M.lualine = function()
  local lualineY = require('lualine').get_config().tabline.lualine_y or {}
  table.insert(lualineY, { pomodoro_text, cond = pomodoro_cond })
  require('lualine').setup { tabline = { lualine_y = lualineY } }
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  require('telescope').load_extension 'pomodori'

  set_keymap('n', '<leader>zps', '<cmd>TimerSession pomodoro<cr>')
  set_keymap('n', '<leader>zpr', '<cmd>TimerResume<cr>')
  set_keymap('n', '<leader>zpp', '<cmd>TimerPause<cr>')

  set_keymap('n', '<leader>zpf', function()
    require('telescope').extensions.pomodori.timers()
  end)
end

M.setup = function()
  ---@diagnostic disable-next-line: missing-fields
  require('pomo').setup {
    notifiers = {
      { name = 'Default', opts = { sticky = false } },
    },
    sessions = {
      pomodoro = {
        { name = 'Work', duration = '25m' },
        { name = 'Short Break', duration = '5m' },
        -- { name = 'Work', duration = '25m' },
        -- { name = 'Short Break', duration = '5m' },
        -- { name = 'Work', duration = '25m' },
        -- { name = 'Long Break', duration = '15m' },
      },
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
  M.lualine()
end

-- M.config()

return M
