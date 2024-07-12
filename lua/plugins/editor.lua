local plugins = {
  'windwp/nvim-autopairs',
  'folke/todo-comments.nvim',
  'alexghergh/nvim-tmux-navigation',
  'mbbill/undotree',
  -- "gbprod/yanky.nvim", -- WARN: irresponsive when switching into terminal
  'Wansmer/treesj',
  'folke/zen-mode.nvim',
  -- "shortcuts/no-neck-pain.nvim", --TODO: Split doesn't work
  'RRethy/vim-illuminate',
  'kevinhwang91/nvim-ufo',
  'norcalli/nvim-colorizer.lua',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Autoclose
  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    cond = conds['windwp/nvim-autopairs'] or false,
    opts = {}
  },
  -- Todo comments
  {
    'nishantpillai5/todo-comments.nvim', -- WARN: Circular todos not merged, using my fork
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    cond = conds['folke/todo-comments.nvim'] or false,
    config = require('config.todo_comments').config,
  },
  -- Tmux like navigation
  {
    'alexghergh/nvim-tmux-navigation',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['alexghergh/nvim-tmux-navigation'] or false,
    config = function()
      local nvim_tmux_nav = require 'nvim-tmux-navigation'
      nvim_tmux_nav.setup {
        disable_when_zoomed = true, -- defaults to false
      }

      vim.keymap.set('n', '<C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', '<C-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', '<C-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', '<C-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set('n', '<C-Space>', nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set('n', '<C-\\>', nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
  -- Better undo
  {
    'mbbill/undotree',
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'undotree_toggle' },
    },
    cond = conds['mbbill/undotree'] or false,
  },
  -- Better yank
  {
    'gbprod/yanky.nvim',
    event = 'VeryLazy',
    cond = conds['gbprod/yanky.nvim'] or false,
    config = function()
      require('yanky').setup {
        highlight = {
          timer = 200,
        },
      }
      vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
      vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

      vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
      vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')
    end,
  },
  -- Better join
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cond = conds['Wansmer/treesj'] or false,
    keys = {
      { '<space>J', "<cmd>lua require('treesj').toggle()<cr>", desc = 'code_join' },
      -- { "<space>Jm", "<cmd>lua require('treesj').join()<cr>", desc = "code join" },
      -- { "<space>Js", "<cmd>lua require('treesj').split()<cr>", desc = "code split" }
    },
    opts = {
      use_default_keymaps = false,
    },
  },
  -- Focus window
  {
    'folke/zen-mode.nvim',
    cond = conds['folke/zen-mode.nvim'] or false,
    keys = {
      { '<leader>zz', "<cmd>lua require('zen-mode').toggle()<cr>", desc = 'zen' },
      { '<leader>zZ', "<cmd>lua require('zen-mode').toggle({window = { width = 1 }})<cr>", desc = 'zen_full' },
    },
    opts = {
      window = { width = 0.95 },
      plugins = {
        options = { enabled = true, laststatus = 3 },
        gitsigns = { enabled = false },
      },
    },
  },
  {
    'shortcuts/no-neck-pain.nvim',
    version = '*',
    cond = conds['shortcuts/no-neck-pain.nvim'] or false,
    keys = {
      { '<leader>zz', ':NoNeckPain<cr>', desc = 'zen', silent = true },
    },
  },
  -- Highlight under cursor
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['RRethy/vim-illuminate'] or false,
    config = function()
      require('illuminate').configure {
        providers = {
          'lsp',
          'treesitter',
          'regex',
        },
        filetypes_denylist = {
          'fugitive',
          'dashboard',
        },
      }
    end,
  },
  -- Folds
  {
    'kevinhwang91/nvim-ufo',
    event = 'VeryLazy',
    dependencies = { 'kevinhwang91/promise-async' },
    cond = conds['kevinhwang91/nvim-ufo'] or false,
    init = require('config.ufo').init,
    config = require('config.ufo').config,
  },
  -- Highlight color info inline
  {
    'norcalli/nvim-colorizer.lua',
    event = 'VeryLazy',
    cond = conds['norcalli/nvim-colorizer.lua'] or false,
    config = function()
      require('colorizer').setup(
        { 'lua', 'css', 'javascript', html = { mode = 'foreground' } },
        { mode = 'background' }
      )
    end,
  },
}
