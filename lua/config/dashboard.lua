local M = {}

local logo1 = {
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

local logo2 = {
  '                  .^. .  –                  ',
  '                 /: ||`/ ~  ,               ',
  "               , [   &    /  y'             ",
  "              {v':   `   / `&~-,            ",
  "             'y. '    |`   ˙  ' /           ",
  "                 '  .       , y             ",
  '              v .              v            ',
  '              V  .~.      .~.  V            ',
  '              : (  0)    (  0) :            ',
  "               i `'`      `'` j             ",
  '                i     __    ,j              ',
  "                 `%`~....~'&                ",
  "                <~o' /  /` -S,              ",
  "               o.~'.  )(  r  .o ,.          ",
  "              o',  %``/``& : 'bF            ",
  "             d', ,ri.~~-~.ri , +h           ",
  "             `oso' d`~..~`b 'sos`           ",
  '                  d`+ II +`b                ',
  '                  i_:_yi_;y                 ',
  '                                            ',
}

local logo3 = {
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

local function get_datetime()
  return os.date '%A == %B %d == %H:%M'
end

M.setup = function()
  require('dashboard').setup {
    theme = 'hyper',
    change_to_vcs_root = true,
    config = {
      header = logo1,
      week_header = { enable = false },
      packages = { enable = false },
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
          desc = '󰊳 Update',
          group = '@property',
          action = 'Lazy update',
          key = 'u',
        },
      },
      footer = { get_datetime() },
    },
  }
end

return M
