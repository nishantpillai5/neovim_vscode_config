local M = {}

local logo = {
"                  .^. .  –                  ",
"                 /: ||`/ ~  ,               ",
"               , [   &    /  y'             ",
"              {v':   `   / `&~-,            ",
"             'y. '    |`   ˙  ' /           ",
"                 '  .       , y             ",
"              v .              v            ",
"              V  .~.      .~.  V            ",
"              : (  0)    (  0) :            ",
"               i `'`      `'` j             ",
"                i     __    ,j              ",
"                 `%`~....~'&                ",
"                <~o' /  /` -S,              ",
"               o.~'.  )(  r  .o ,.          ",
"              o',  %``/``& : 'bF            ",
"             d', ,ri.~~-~.ri , +h           ",
"             `oso' d`~..~`b 'sos`           ",
"                  d`+ II +`b                ",
"                  i_:_yi_;y                 ",
"                                            ",
}

local logo2 = {
" ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓",
" ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒",
"▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░",
"▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ",
"▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒",
"░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░",
"░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░",
"   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ",
"         ░    ░  ░    ░ ░        ░   ░         ░   ",
"                                 ░                 ",
}

local function get_datetime()
    return os.date("%A == %B %d == %H:%M")
end

M.setup = function ()
  require("dashboard").setup({
    theme = "hyper",
    change_to_vcs_root = true,
    config = {
      header = logo2,
      week_header = { enable = false },
      packages = { enable = true },
      project = { enable = false, limit = 1 },
      mru = { cwd_only = true, limit = 5 },
      shortcut = {
        {
          desc = " Files",
          group = "Label",
          action = "Telescope find_files",
          key = "f",
        },
        {
          desc = "󰊳 Update",
          group = "@property",
          action = "Lazy update",
          key = "u",
        },
      },
      footer = { get_datetime() },
    },
  })
end

return M
