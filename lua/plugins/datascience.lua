local plugins = {
  'benlubas/molten-nvim',
  -- '3rd/image.nvim',
  'jmbuhr/otter.nvim',
  'quarto-dev/quarto-nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {

  {
    'benlubas/molten-nvim',
    cond = conds['benlubas/molten-nvim'] or false,
    cmd = { 'MoltenInit', 'MoltenEvaluateLine' },
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    -- dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      -- these are examples, not defaults. Please see the readme
      -- vim.g.molten_image_provider = 'none'
      -- vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
    end,
  },
  {
    '3rd/image.nvim',
    cond = conds['3rd/image.nvim'] or false,
    opts = {
      backend = 'kitty', -- whatever backend you would like to use
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
  },
  {
    'jmbuhr/otter.nvim',
    lazy = true,
    cond = conds['jmbuhr/otter.nvim'] or false,
    opts = {
      buffers = {
        set_filetype = true,
      },
    },
  },
  {
    'quarto-dev/quarto-nvim',
    cond = conds['quarto-dev/quarto-nvim'] or false,
    ft = 'quarto',
    dependencies = {
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = require('config.quarto').keys,
    config = require('config.quarto').config,
  },
}
