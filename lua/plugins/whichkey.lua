local plugins = {
  'folke/which-key.nvim',
  'tris203/hawtkeys.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Shortcut helper
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    cond = conds['folke/which-key.nvim'] or false,
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    keys = {
      {
        '<leader><leader>',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'whichkey_help',
      },
    },
    config = function()
      local wk = require 'which-key'
      wk.setup {
        icons = { rules = false },
        triggers = {
          { '<auto>', mode = 'nixsotc' },
          { 'm', mode = { 'n', 'v' } },
        },
        sort = { 'local', 'order', 'group', 'alphanum', 'mod', 'lower', 'icase' },
        spec = {
          { '<leader>;', group = 'Terminal' },
          { '<leader>b', group = 'Breakpoint' },
          { '<leader>c', group = 'Chat', mode = { 'n', 'v' } },
          { '<leader>e', group = 'Explorer' },
          { '<leader>ey', group = 'Yank' },
          { '<leader>f', group = 'Find', mode = { 'n', 'v' } },
          { '<leader>fg', group = 'Git' },
          { '<leader>fb', group = 'Breakpoint' },
          { '<leader>F', group = 'Find_Telescope' },
          { '<leader>g', group = 'Git', mode = { 'n', 'v' } },
          { '<leader>gh', group = 'Hunk', mode = { 'n', 'v' } },
          { '<leader>go', group = 'Open' },
          { '<leader>gx', group = 'Conflict' },
          { '<leader>l', group = 'LSP', mode = { 'n', 'v' } },
          { '<leader>n', group = 'Notes' },
          { '<leader>o', group = 'Tasks' },
          { '<leader>os', group = 'Save' },
          { '<leader>r', group = 'Refactor' },
          { '<leader>t', group = 'Trouble' },
          { '<leader>w', group = 'Workspace' },
          { '<leader>z', group = 'Visual', mode = { 'n', 'v' } },
          { '<leader>zf', group = 'fml' },
          { ']', group = 'Next' },
          { '[', group = 'Prev' },

          { ']d', desc = 'diagnostic' },
          { '[d', desc = 'diagnostic' },

          { 'm', group = 'Marks' },
          { 'md', desc = 'delete_in_buffer' },
          { 'mD', desc = 'delete_all' },
          { 'mm', desc = 'mark' },
          { 'mn', desc = 'nearest' },
          { 'mp', desc = 'paste_last' },
          { 'mP', desc = 'paste_all' },
          { 'mx', desc = 'back' },

          { '<C-h>', desc = 'move_focus_left' },
          { '<C-j>', desc = 'move_focus_down' },
          { '<C-k>', desc = 'move_focus_up' },
          { '<C-l>', desc = 'move_focus_right' },

          { 'gd', desc = 'definition' },
          { 'gD', desc = 'declaration' },
          { 'gi', desc = 'implementation' },
          { 'go', desc = 'symbol' },
          { 'gr', desc = 'references' },
          { 'gh', desc = 'signature_help' },
          { 'gl', desc = 'diagnostics' },

          { 'K', desc = 'hover' },
          { 's', desc = 'hop_char' },
          { 'S', desc = 'hop_node' },

          { '<F2>', desc = 'rename' },
          { '<F3>', desc = 'format_lsp' },
          { '<F4>', desc = 'code_action' },
        },
      }
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
