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
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['kylechui/nvim-surround'] or false,
    version = '*',
    opts = {},
  },
  -- Marks
  {
    'LeonHeidelbach/trailblazer.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['LeonHeidelbach/trailblazer.nvim'] or false,
    config = require('config.trailblazer').config,
  },
  -- Change variable case format
  {
    'gregorias/coerce.nvim',
    cond = conds['gregorias/coerce.nvim'] or false,
    tag = 'v1.0',
    keys = {
      { 'cr', desc = 'change_var_format' },
    },
    opts = {},
  },
  -- Better increment
  {
    'monaqa/dial.nvim',
    cond = conds['monaqa/dial.nvim'] or false,
    keys = require('config.dial').keys,
    config = require('config.dial').config,
  },
  -- Better macros
  {
    'chrisgrieser/nvim-recorder',
    cond = conds['chrisgrieser/nvim-recorder'] or false,
    keys = require('config.recorder').keys,
    config = require('config.recorder').config,
  },
  -- Inline macros
  {
    'AllenDang/nvim-expand-expr',
    cond = conds['AllenDang/nvim-expand-expr'] or false,
    keys = {
      { '<leader>q', ":lua require('expand_expr').expand()<cr>", desc = 'inline_macro' }
    },
  },
  -- Align expressions
  {
    'echasnovski/mini.align',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['echasnovski/mini.align'] or false,
    opts = {},
  },
}
