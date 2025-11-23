local plugins = {
  'vhyrro/luarocks.nvim',
  'eandrju/cellular-automaton.nvim',
  'kwakzalver/duckytype.nvim',
  'dstein64/vim-startuptime',
  'subnut/nvim-ghost.nvim',
  -- 'm4xshen/hardtime.nvim',
  'theprimeagen/vim-be-good',
  'seandewar/killersheep.nvim',
  'epwalsh/pomo.nvim',
  'gruvw/strudel.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- for installing Luarocks dependencies
  {
    'vhyrro/luarocks.nvim',
    lazy = true,
    -- priority = 1001,
    event = 'VeryLazy',
    cond = conds['vhyrro/luarocks.nvim'] or false,
    config = true,
    opts = {
      -- rocks = { 'lua-curl', 'nvim-nio', 'mimetypes', 'xml2lua', 'tiktoken_core' },
      rocks = { 'tiktoken_core' },
    },
  },
  -- Check startup time stats
  {
    'dstein64/vim-startuptime',
    lazy = true,
    cond = conds['dstein64/vim-startuptime'] or false,
    cmd = 'StartupTime',
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  -- Use nvim to type online
  {
    'subnut/nvim-ghost.nvim',
    lazy = true,
    cond = conds['subnut/nvim-ghost.nvim'] or false,
    cmd = 'GhostTextStart',
    init = function()
      vim.g.nvim_ghost_autostart = 0
    end,
  },
  -- Learn vim
  {
    'm4xshen/hardtime.nvim',
    lazy = true,
    -- event = 'VeryLazy',
    event = 'BufReadPost',
    cond = not require('common.env').PRESENTING and (conds['m4xshen/hardtime.nvim'] or false),
    keys = {
      { '<leader>zOh', '<cmd>Hardtime toggle<cr>', desc = 'toggle_hardtime' },
    },
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {
      disabled_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'mason', 'oil', 'calendar', 'neo-tree', 'fugitive' },
    },
  },
  {
    'theprimeagen/vim-be-good',
    lazy = true,
    cond = conds['theprimeagen/vim-be-good'] or false,
    cmd = 'VimBeGood',
  },
  -- When nothing works
  {
    'eandrju/cellular-automaton.nvim',
    lazy = true,
    cond = conds['eandrju/cellular-automaton.nvim'] or false,
    cmd = 'CellularAutomaton',
    keys = {
      { '<leader>zOf', '<cmd>CellularAutomaton make_it_rain<cr>', desc = 'fml' },
      { '<leader>zOw', '<cmd>CellularAutomaton scramble<cr>', desc = 'too_much_work' },
    },
  },
  -- Typing test
  {
    'kwakzalver/duckytype.nvim',
    lazy = true,
    cond = conds['kwakzalver/duckytype.nvim'] or false,
    cmd = 'DuckyType',
    keys = {
      { '<leader>zOt', '<cmd>DuckyType english_common<cr>', desc = 'typing_test_eng' },
      { '<leader>zOT', '<cmd>DuckyType cpp_keywords<cr>', desc = 'typing_test_code' },
    },
    opts = {},
  },
  -- GOTY
  {
    'seandewar/killersheep.nvim',
    lazy = true,
    cond = conds['seandewar/killersheep.nvim'] or false,
    cmd = 'KillKillKill',
    keys = {
      { '<leader>zOs', '<cmd>KillKillKill<cr>', desc = 'sheep_game' },
    },
    opts = {
      gore = true,
      keymaps = {
        move_left = 'j',
        move_right = 'k',
        shoot = '<Space>',
      },
    },
  },
  {
    'epwalsh/pomo.nvim',
    lazy = true,
    cond = conds['epwalsh/pomo.nvim'] or false,
    version = '*', -- Recommended, use latest release instead of latest commit
    dependencies = { 'rcarriga/nvim-notify' },
    cmd = require('config.pomodoro').cmd,
    keys = require('config.pomodoro').keys,
    config = require('config.pomodoro').config,
  },
  {
    'gruvw/strudel.nvim',
    lazy = true,
    event = "BufRead *.str",
    cond = conds['gruvw/strudel.nvim'] or false,
    cmd = require('config.strudel').cmd,
    keys = require('config.strudel').keys,
    build = 'npm install',
    config = require('config.strudel').config,
  },
}
