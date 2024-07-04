local plugins = {
  'windwp/nvim-autopairs',
  -- 'folke/todo-comments.nvim', -- Circular todos not merged, using my fork
  'nishantpillai5/todo-comments.nvim',
  'alexghergh/nvim-tmux-navigation',
  'mbbill/undotree',
  -- "gbprod/yanky.nvim", -- WARN: irresponsive when switching into terminal
  'Wansmer/treesj',
  'folke/zen-mode.nvim',
  -- "shortcuts/no-neck-pain.nvim", --TODO: Split doesn't work
  -- 'sitiom/nvim-numbertoggle', -- TODO: no line numbers when jumping with trouble
  'RRethy/vim-illuminate',
  'kevinhwang91/nvim-ufo',
  'norcalli/nvim-colorizer.lua',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Autoclose
  {
    'windwp/nvim-autopairs',
    cond = conds['windwp/nvim-autopairs'] or false,
    event = 'InsertEnter',
    config = true,
  },
  -- Todo comments
  {
    'nishantpillai5/todo-comments.nvim',
    cond = conds['nishantpillai5/todo-comments.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = require('config.todo_comments').config,
  },
  -- Tmux like navigation
  {
    'alexghergh/nvim-tmux-navigation',
    cond = conds['alexghergh/nvim-tmux-navigation'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
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
    cond = conds['mbbill/undotree'] or false,
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'undotree_toggle' },
    },
  },
  -- Better yank
  {
    'gbprod/yanky.nvim',
    cond = conds['gbprod/yanky.nvim'] or false,
    event = 'VeryLazy',
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
    cond = conds['Wansmer/treesj'] or false,
    opts = {
      use_default_keymaps = false,
    },
    keys = {
      { '<space>J', "<cmd>lua require('treesj').toggle()<cr>", desc = 'code_join' },
      -- { "<space>Jm", "<cmd>lua require('treesj').join()<cr>", desc = "code join" },
      -- { "<space>Js", "<cmd>lua require('treesj').split()<cr>", desc = "code split" }
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
  -- Absolute line numbers when not focused
  {
    'sitiom/nvim-numbertoggle',
    cond = conds['sitiom/nvim-numbertoggle'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
  },
  -- Highlight under cursor
  {
    'RRethy/vim-illuminate',
    cond = conds['RRethy/vim-illuminate'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
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
    cond = conds['kevinhwang91/nvim-ufo'] or false,
    event = 'VeryLazy',
    dependencies = { 'kevinhwang91/promise-async' },
    init = function()
      require('config.ufo').init()
    end,
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
