_G.LOGO = _G.LOGO or nil

local M = {}

local function get_logo()
  local ascii = require 'nvim.ascii'
  local context = require('common.env').NVIM_CONTEXT
  local logo = ascii.default_logo

  if context == 'work' or context == 'present' then
    local logos = ascii.work_logos
    local rand_n = os.time() % #logos + 1
    logo = _G.LOGO or logos[rand_n]
  end

  return logo
end

local function get_datetime()
  return os.date '%A == %B %d == %H:%M'
end

M.setup = function()
  require('dashboard').setup {
    theme = 'hyper',
    change_to_vcs_root = false,
    shortcuts_left_side = false,
    shortcut_type = 'number',
    config = {
      header = get_logo(),
      week_header = { enable = false },
      packages = { enable = true },
      project = { enable = false, limit = 1 },
      mru = { cwd_only = true, limit = 5 },
      shortcut = {
        {
          desc = ' Files',
          group = 'Label',
          action = 'Telescope find_files',
          key = 'f',
        },
        {
          desc = ' Explorer',
          group = 'Label',
          action = 'Neotree reveal focus',
          key = 'e',
        },
        {
          desc = ' Recent',
          group = 'Label',
          action = 'Telescope oldfiles only_cwd=true',
          key = 'r',
        },
        {
          desc = '󱇳 Scope',
          group = 'Label',
          action = require('config.neoscopes').setup,
          key = 'w',
        },
        {
          desc = ' Project',
          group = 'Label',
          action = 'Telescope project',
          key = 'W',
        },
        {
          desc = '󰒲 Lazy',
          group = '@property',
          action = 'Lazy',
          key = 'l',
        },
      },
      -- footer = { get_datetime() },
      footer = {},
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M