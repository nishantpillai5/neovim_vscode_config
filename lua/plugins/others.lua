local plugins = {
  'vhyrro/luarocks.nvim',
  'eandrju/cellular-automaton.nvim',
  'kwakzalver/duckytype.nvim',
  'dstein64/vim-startuptime',
  'subnut/nvim-ghost.nvim',
  -- 'm4xshen/hardtime.nvim',
  'theprimeagen/vim-be-good',
  'seandewar/killersheep.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- for installing Luarocks dependencies
  {
    'vhyrro/luarocks.nvim',
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
    cond = conds['dstein64/vim-startuptime'] or false,
    cmd = 'StartupTime',
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  -- Use nvim to type online
  {
    'subnut/nvim-ghost.nvim',
    cond = conds['subnut/nvim-ghost.nvim'] or false,
    cmd = 'GhostTextStart',
    init = function()
      vim.g.nvim_ghost_autostart = 0
    end,
  },
  -- Learn vim
  {
    'm4xshen/hardtime.nvim',
    -- event = 'VeryLazy',
    event = 'BufReadPost',
    cond = not require('common.env').PRESENTING and (conds['m4xshen/hardtime.nvim'] or false),
    keys = {
      { '<leader>zoh', '<cmd>Hardtime toggle<cr>', desc = 'toggle_hardtime' },
    },
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {
      disabled_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'mason', 'oil', 'calendar', 'neo-tree', 'fugitive' },
    },
  },
  {
    'theprimeagen/vim-be-good',
    cond = conds['theprimeagen/vim-be-good'] or false,
    cmd = 'VimBeGood',
    lazy = true,
  },
  -- When nothing works
  {
    'eandrju/cellular-automaton.nvim',
    cond = conds['eandrju/cellular-automaton.nvim'] or false,
    cmd = 'CellularAutomaton',
    keys = {
      { '<leader>zof', '<cmd>CellularAutomaton make_it_rain<cr>', desc = 'fml' },
      { '<leader>zow', '<cmd>CellularAutomaton scramble<cr>', desc = 'too_much_work' },
    },
  },
  -- Typing test
  {
    'kwakzalver/duckytype.nvim',
    cond = conds['kwakzalver/duckytype.nvim'] or false,
    cmd = 'DuckyType',
    keys = {
      { '<leader>zot', '<cmd>DuckyType english_common<cr>', desc = 'typing_test_eng' },
      { '<leader>zoT', '<cmd>DuckyType cpp_keywords<cr>', desc = 'typing_test_code' },
    },
    opts = {},
  },
  -- GOTY
  {
    'seandewar/killersheep.nvim',
    cond = conds['seandewar/killersheep.nvim'] or false,
    cmd = 'KillKillKill',
    keys = {
      { '<leader>zos', '<cmd>KillKillKill<cr>', desc = 'sheep_game' },
    },
    lazy = true,
    opts = {
      gore = true,
      keymaps = {
        move_left = 'j',
        move_right = 'k',
        shoot = '<Space>',
      },
    },
  },
}
