local plugins = {
  'folke/which-key.nvim',
  'tris203/hawtkeys.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
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
        ['<leader>'] = {
          [';'] = 'Terminal',
          r = 'Refactor',
          l = 'LSP',
          c = { name = 'Chat', t = 'Terminal' },
          f = { name = 'Find', g = 'Git' },
          e = { name = 'Explorer', y = 'Yank' },
          w = 'Workspace/Session',
          t = 'Trouble',
          b = 'Breakpoint',
          n = 'Notes',
          o = 'Build',
          q = 'Quarto',
          z = { name = 'Visual', c = 'Context', g = 'Git' },
          g = { name = 'Git', h = 'Hunk' },
          ['/'] = 'Search',
        },
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
        ['[d'] = 'prev.diagnostic',
        [']d'] = 'next.diagnostic',
        K = 'hover',
        s = 'hop_char',
        S = 'hop_node',
        d = { m = { name = '+Marks' } },
        m = {
          name = '+Marks',
          [';'] = 'Marks.mark_toggle',
          [','] = 'Marks.mark_set',
        },
      }

      wk.register({
        ['<leader>'] = {
          c = 'Chat',
          g = { name = 'Git', h = 'Hunk' },
          l = 'LSP',
          ['/'] = 'Search',
        },
      }, { mode = 'v' })
    end,
  },
  {
    'tris203/hawtkeys.nvim',
    cond = conds['tris203/hawtkeys.nvim'] or false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "Hawtkeys", "HawtkeysAll", "HawtkeysDupes" },
    config = {
      customMaps = {
        ["wk.register"] = {
            method = "which_key",
        },
        ["lazy"] = {
            method = "lazy",
        },
      },
    },
  }
}
