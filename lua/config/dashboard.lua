local M = {}

local LOGO1 = {
  ' ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓',
  ' ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒',
  '▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░',
  '▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ',
  '▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒',
  '░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░',
  '░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░',
  '   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ',
  '         ░    ░  ░    ░ ░        ░   ░         ░   ',
  '                                 ░                 ',
}

local LOGO2 = {
  '      .^. .  –                                                         ',
  '     /: ||`/ ~  ,                                                      ',
  "   , [   &    /  y'                                                    ",
  "  {v':   `   / `&~-,                                                   ",
  " 'y. '    |`   ˙  ' /                                                  ",
  "     '  .       , y                                               d8P  ",
  '  v .              v                                           d888888P',
  "  V  .~.      .~.  V         d888b8b    88bd88b d8888b  d8888b   ?88'  ",
  "  : (  0)    (  0) :        d8P' ?88    88P'  `d8P' ?88d8P' ?88  88P   ",
  "   i `'`      `'` j         88b  ,88b  d88     88b  d8888b  d88  88b   ",
  "    i     __    ,j          `?88P'`88bd88'     `?8888P'`?8888P'  `?8b  ",
  "     `%`~....~'&                   )88                                 ",
  "    <~o' /  /` -S,                ,88P                                 ",
  "   o.~'.  )(  r  .o ,.        `?8888P                                  ",
  "  o',  %``/``& : 'bF                                                   ",
  " d', ,ri.~~-~.ri , +h                                                  ",
  " `oso' d`~..~`b 'sos`                                                  ",
  '      d`+ II +`b                                                       ',
  '      i_:_yi_;y                                                        ',
  '                                                                       ',
}

local function get_logo()
  local context = require('common.env').CONTEXT
  if context == 'work' then
    return LOGO2
  else
    return LOGO1
  end
end

local function get_datetime()
  return os.date '%A == %B %d == %H:%M'
end

M.setup = function()
  require('dashboard').setup {
    theme = 'hyper',
    change_to_vcs_root = true,
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
          desc = ' Recent',
          group = 'Label',
          action = 'Telescope oldfiles only_cwd=true',
          key = 'r',
        },
        {
          desc = '󱇳 Scope',
          group = 'Label',
          action = require('config.neoscopes').select_scope,
          key = 'w',
        },
        {
          desc = ' Workspace',
          group = 'Label',
          action = 'Telescope projects',
          key = 'W',
        },
        {
          desc = '󰒲 Lazy',
          group = '@property',
          action = 'Lazy',
          key = 'l',
        },
      },
      footer = { get_datetime() },
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
