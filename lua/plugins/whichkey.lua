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
        ['<leader>'] = {
          name = "Shortcuts",
          [';'] = 'Terminal',
          r = 'Refactor',
          l = 'LSP',
          c = { name = 'Chat' },
          f = { name = 'Find', g = 'Git', b='Breakpoint' },
          F = { name = 'Find_Telescope' },
          e = { name = 'Explorer', y = 'Yank' },
          w = 'Workspace',
          t = 'Trouble',
          b = 'Breakpoint',
          n = 'Notes',
          o = 'Tasks',
          q = 'Quarto',
          z = { name = 'Visual', g = 'Git' },
          g = { name = 'Git', h = 'Hunk' },
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
        [']'] = { name = 'Next' , d = 'Next.diagnostic' },
        ['['] = { name = 'Prev' , d = 'Prev.diagnostic' },
        K = 'hover',
        s = 'hop_char',
        d = { m = { name = '+Marks' } },
        m = {
          name = '+Marks',
          [';'] = 'Marks.mark_toggle',
          [','] = 'Marks.mark_set',
        },
        ['<C-h>'] = 'move_focus_left',
        ['<C-j>'] = 'move_focus_down',
        ['<C-k>'] = 'move_focus_up',
        ['<C-l>'] = 'move_focus_right',
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
  -- Find shortcut conflicts
  {
    'tris203/hawtkeys.nvim',
    cond = conds['tris203/hawtkeys.nvim'] or false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "Hawtkeys", "HawtkeysAll", "HawtkeysDupes" },
    opts = {
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
