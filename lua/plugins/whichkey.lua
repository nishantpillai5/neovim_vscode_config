local plugins = {
  'folke/which-key.nvim',
  'tris203/hawtkeys.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Shortcut helper
  {
    'folke/which-key.nvim',
    cond = conds['folke/which-key.nvim'] or false,
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require 'which-key'
      wk.register {
        ['<leader>'] = require("common.whichkey_config").leader_maps,
        g = {
          d = 'definition',
          D = 'declaration',
          i = 'implementation',
          o = 'symbol',
          r = 'references',
          h = 'signature help',
          l = 'diagnostics',
        },
        ['<F2>'] = 'rename',
        ['<F3>'] = 'format(lsp)',
        ['<F4>'] = 'code_action',
        [']'] = { name = 'Next', d = 'diagnostic' },
        ['['] = { name = 'Prev', d = 'diagnostic' },
        K = 'hover',
        s = 'hop_char',
        S = 'hop_node',
        m = { name = '+Mark', b = 'back', d='delete', D = 'delete_all', m = 'mark', n = 'nearest', p = 'paste_last', P = 'paste_all' },
        ['<C-h>'] = 'move_focus_left',
        ['<C-j>'] = 'move_focus_down',
        ['<C-k>'] = 'move_focus_up',
        ['<C-l>'] = 'move_focus_right',
      }

      wk.register({
        ['<leader>'] = {
          c = 'Chat',
          f = 'Find',
          g = { name = 'Git', h = 'Hunk' },
          l = 'LSP',
          ['/'] = 'Search',
        },
      }, { mode = 'v' })
    end,
  },
  -- Find shortcut conflicts
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
