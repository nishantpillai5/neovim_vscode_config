local plugins = {
  'smoka7/hop.nvim',
  'kylechui/nvim-surround',
  'LeonHeidelbach/trailblazer.nvim',
  'gregorias/coerce.nvim',
  'monaqa/dial.nvim',
  'chrisgrieser/nvim-recorder',
  'AllenDang/nvim-expand-expr',
  'echasnovski/mini.align',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Hop around text
  {
    'smoka7/hop.nvim',
    cond = conds['smoka7/hop.nvim'] or false,
    keys = {
      { 's', '<cmd>HopChar2<cr>', mode = { 'n', 'x' }, desc = 'hop_char' },
      { 'S', '<cmd>HopNodes<cr>', mode = { 'n' }, desc = 'hop_node' },
    },
    opts = {
      multi_windows = true,
      uppercase_labels = true,
      jump_on_sole_occurrence = false,
    },
  },
  -- Surround
  {
    'kylechui/nvim-surround',
    cond = conds['kylechui/nvim-surround'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    version = '*',
    config = function()
      require('nvim-surround').setup {}
    end,
  },
  -- Marks
  {
    'LeonHeidelbach/trailblazer.nvim',
    cond = conds['LeonHeidelbach/trailblazer.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    config = require('config.trailblazer').config,
  },
  -- Change variable case format
  {
    'gregorias/coerce.nvim',
    cond = conds['gregorias/coerce.nvim'] or false,
    keys = {
      { 'cr', desc = 'coerce' },
    },
    tag = 'v1.0',
    opts = {},
  },
  -- Better increment
  {
    'monaqa/dial.nvim',
    cond = conds['monaqa/dial.nvim'] or false,
    keys = {
      { '<leader>i', "<cmd>lua require('dial.map').manipulate('increment', 'normal')<cr>", desc = 'increment' },
      { '<leader>I', "<cmd>lua require('dial.map').manipulate('decrement', 'normal')<cr>", desc = 'decrement' },
    },
    config = function()
      local augend = require 'dial.augend'
      require('dial.config').augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.semver.alias.semver,
          augend.date.alias['%Y/%m/%d'],
        },
      }
    end,
  },
  -- Better macros
  {
    'chrisgrieser/nvim-recorder',
    cond = conds['chrisgrieser/nvim-recorder'] or false,
    keys = {
      { 'q', desc = 'macro_record' },
      { 'cq', desc = 'macro' },
      { 'dq', desc = 'macro' },
      { 'yq', desc = 'macro' },
      { 'Q', desc = 'macro_play' },
      { '<leader>q', desc = 'switch_macro_slot' },
    },
    config = require('config.recorder').config,
  },
  -- Inline macros
  {
    'AllenDang/nvim-expand-expr',
    cond = conds['AllenDang/nvim-expand-expr'] or false,
    keys = {
      {
        '<leader>q',
        function()
          require('expand_expr').expand()
        end,
        desc = 'inline_macro',
      },
    },
  },
  -- Align expressions
  {
    'echasnovski/mini.align',
    cond = conds['echasnovski/mini.align'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mini.align').setup()
    end,
  },
}
