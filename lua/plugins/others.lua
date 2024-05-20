local plugins = {
  'eandrju/cellular-automaton.nvim',
  'kwakzalver/duckytype.nvim',
  'dstein64/vim-startuptime',
  'subnut/nvim-ghost.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'eandrju/cellular-automaton.nvim',
    cond = conds['eandrju/cellular-automaton.nvim'] or false,
    keys = {
      { '<leader>zf', '<cmd>CellularAutomaton make_it_rain<cr>', desc = 'Visual.fml' },
    },
  },
  {
    'kwakzalver/duckytype.nvim',
    cond = conds['kwakzalver/duckytype.nvim'] or false,
    keys = {
      { '<leader>zt', '<cmd>DuckyType cpp_keywords<cr>', desc = 'Visual.typing_test' },
    },
    config = function()
      require('duckytype').setup {}
    end,
  },
  {
    'dstein64/vim-startuptime',
    cond = conds['dstein64/vim-startuptime'] or false,
    cmd = 'StartupTime',
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    'subnut/nvim-ghost.nvim',
    lazy = true,
    cond = conds['subnut/nvim-ghost.nvim'] or false,
    cmd = { 'GhostTextStart' },
  },
}
