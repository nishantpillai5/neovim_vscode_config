local plugins = {
  'quarto-dev/quarto-nvim',
  'benlubas/molten-nvim',
  -- '3rd/image.nvim',
  'jmbuhr/otter.nvim',
  'jbyuki/nabla.nvim',
  -- 'GCBallesteros/jupytext.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- ipynb in nvim
  {
    'quarto-dev/quarto-nvim',
    cond = conds['quarto-dev/quarto-nvim'] or false,
    dependencies = {
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
      'benlubas/molten-nvim',
    },
    keys = require('config.quarto').keys,
    config = require('config.quarto').config,
  },
  -- Code runner inside markdown
  {
    'benlubas/molten-nvim',
    cond = conds['benlubas/molten-nvim'] or false,
    lazy = true,
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    -- dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = require('config.molten').init,
    config = require('config.molten').config,
  },
  -- Image previewer
  {
    '3rd/image.nvim',
    cond = conds['3rd/image.nvim'] or false,
    opts = {
      backend = 'kitty',
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
  },
  -- LSP in markdown
  {
    'jmbuhr/otter.nvim',
    ft = require('config.otter').ft,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'VonHeikemen/lsp-zero.nvim',
    },
    cond = conds['jmbuhr/otter.nvim'] or false,
    config = require('config.otter').config,
  },
  -- preview equations
  {
    'jbyuki/nabla.nvim',
    cond = conds['jbyuki/nabla.nvim'] or false,
    ft = require('config.nabla').ft,
    keys = require('config.nabla').keys,
    config = require('config.nabla').config,
  },
  -- convert ipynb to qmd
  {
    'GCBallesteros/jupytext.nvim',
    cond = conds['GCBallesteros/jupytext.nvim'] or false,
    config = true,
    lazy = false,
  },
}
