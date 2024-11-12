local plugins = {
  'folke/which-key.nvim',
  'tris203/hawtkeys.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Keymap helper
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    cond = conds['folke/which-key.nvim'] or false,
    init = require('config.whichkey').init,
    keys = require('config.whichkey').keys,
    config = require('config.whichkey').config,
  },
  -- Find keymap conflicts
  {
    'tris203/hawtkeys.nvim',
    cond = conds['tris203/hawtkeys.nvim'] or false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    cmd = { 'Hawtkeys', 'HawtkeysAll', 'HawtkeysDupes' },
    opts = {
      customMaps = {
        ['wk.register'] = {
          method = 'which_key',
        },
        ['lazy'] = {
          method = 'lazy',
        },
      },
    },
  },
}
