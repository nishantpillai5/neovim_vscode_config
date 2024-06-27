local plugins = {
  'smoka7/hop.nvim',
  'kylechui/nvim-surround',
  -- 'chentoast/marks.nvim',
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
      -- { 'S', '<cmd>HopNodes<cr>', mode = {'n','x'}, desc = 'hop_node' },
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
    'chentoast/marks.nvim',
    cond = conds['chentoast/marks.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
  {
    'LeonHeidelbach/trailblazer.nvim',
    cond = conds['LeonHeidelbach/trailblazer.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('trailblazer').setup {
        trail_options = {
          multiple_mark_symbol_counters_enabled = false,
          trail_mark_in_text_highlights_enabled = false,
        },
        force_mappings = {
          nv = {
            motions = {
              new_trail_mark = 'mm',
              track_back = 'mb',
              peek_move_next_down = '<A-PageDown>',
              peek_move_previous_up = '<A-PageUp>',
              move_to_nearest = '<A-m>',
              toggle_trail_mark_list = 'M',
            },
            actions = {
              delete_all_trail_marks = 'mD',
              paste_at_last_trail_mark = 'mp',
              paste_at_all_trail_marks = 'mP',
            },
          },
        },
      }
    end,
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
      { 'Q', desc = 'macro_play' },
    },
    config = require('config.recorder').config,
  },
  -- Inline macros
  {
    'AllenDang/nvim-expand-expr',
    cond = conds['AllenDang/nvim-expand-expr'] or false,
    keys = {
      {
        '<leader>oq',
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
