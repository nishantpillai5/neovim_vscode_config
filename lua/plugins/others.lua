local plugins = {
  'eandrju/cellular-automaton.nvim',
  'kwakzalver/duckytype.nvim',
  'dstein64/vim-startuptime',
  'subnut/nvim-ghost.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- When nothing works
  {
    'eandrju/cellular-automaton.nvim',
    cond = conds['eandrju/cellular-automaton.nvim'] or false,
    cmd = 'CellularAutomaton',
    keys = {
      { '<leader>zff', '<cmd>CellularAutomaton make_it_rain<cr>', desc = 'fml' },
      { '<leader>zft', '<cmd>CellularAutomaton scramble<cr>', desc = 'too_much_work' },
    },
  },
  -- Typing test
  {
    'kwakzalver/duckytype.nvim',
    cond = conds['kwakzalver/duckytype.nvim'] or false,
    cmd = 'DuckyType',
    keys = {
      { '<leader>zt', '<cmd>DuckyType english_common<cr>', desc = 'typing_test_eng' },
      { '<leader>zT', '<cmd>DuckyType cpp_keywords<cr>', desc = 'typing_test_code' },
    },
    opts = {},
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
}
