local plugins = {
  'chrisgrieser/nvim-spider',
  'smoka7/hop.nvim',
  'kylechui/nvim-surround',
  'LeonHeidelbach/trailblazer.nvim',
  -- 'gregorias/coerce.nvim', -- TODO: conflicts with gcc
  'monaqa/dial.nvim',
  'chrisgrieser/nvim-recorder',
  'AllenDang/nvim-expand-expr',
  'echasnovski/mini.align',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  {
    'chrisgrieser/nvim-spider',
    lazy = true,
    cond = conds['chrisgrieser/nvim-spider'] or false,
    keys = {
      { 'W', "<cmd>lua require('spider').motion('w')<CR>", mode = { 'n', 'o', 'x' } },
      { 'E', "<cmd>lua require('spider').motion('e')<CR>", mode = { 'n', 'o', 'x' } },
      { 'B', "<cmd>lua require('spider').motion('b')<CR>", mode = { 'n', 'o', 'x' } },
    },
    config = function()
      require('spider').setup {
        skipInsignificantPunctuation = true,
        consistentOperatorPending = false,
        subwordMovement = true,
        customPatterns = {},
      }
    end,
  },
  -- Hop around text
  {
    'smoka7/hop.nvim',
    lazy = true,
    cond = conds['smoka7/hop.nvim'] or false,
    keys = {
      { 's', '<cmd>HopChar2<cr>', mode = { 'n', 'x' }, desc = 'hop_char' },
      { 'S', '<cmd>HopNodes<cr>', mode = { 'n' }, desc = 'hop_node' },
    },
    cmd = { 'HopChar2', 'HopNodes' },
    opts = {
      multi_windows = true,
      uppercase_labels = true,
      jump_on_sole_occurrence = false,
    },
  },
  -- Surround
  {
    'kylechui/nvim-surround',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    version = '*',
    cond = conds['kylechui/nvim-surround'] or false,
    opts = {},
  },
  -- Marks
  {
    'LeonHeidelbach/trailblazer.nvim',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    -- event = 'VeryLazy',
    cond = conds['LeonHeidelbach/trailblazer.nvim'] or false,
    keys = require('config.trailblazer').keys,
    config = require('config.trailblazer').config,
  },
  -- Change variable case format
  {
    'gregorias/coerce.nvim',
    lazy = true,
    tag = 'v1.0',
    cond = conds['gregorias/coerce.nvim'] or false,
    keys = {
      { 'cr', desc = 'change_var_format' },
      { 'gcr', group = 'change_var_motion', mode = 'n' },
      { 'gcr', group = 'change_var_selection', mode = 'v' },
    },
    config = true,
  },
  -- Better increment
  {
    'monaqa/dial.nvim',
    lazy = true,
    cond = conds['monaqa/dial.nvim'] or false,
    keys = require('config.dial').keys,
    config = require('config.dial').config,
  },
  -- Better macros
  {
    'chrisgrieser/nvim-recorder',
    lazy = true,
    cond = conds['chrisgrieser/nvim-recorder'] or false,
    keys = require('config.recorder').keys,
    config = require('config.recorder').config,
  },
  -- Inline macros
  {
    'AllenDang/nvim-expand-expr',
    lazy = true,
    cond = conds['AllenDang/nvim-expand-expr'] or false,
    keys = {
      { '<leader>Q', ":lua require('expand_expr').expand()<cr>", desc = 'inline_macro' },
    },
  },
  -- Align expressions
  {
    'echasnovski/mini.align',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['echasnovski/mini.align'] or false,
    opts = {},
  },
}
