local plugins = {
  'windwp/nvim-autopairs',
  'folke/todo-comments.nvim',
  'alexghergh/nvim-tmux-navigation',
  'mbbill/undotree',
  'gbprod/yanky.nvim',
  'Wansmer/treesj',
  'folke/zen-mode.nvim',
  'RRethy/vim-illuminate',
  'kevinhwang91/nvim-ufo',
  'norcalli/nvim-colorizer.lua',
  'andrewferrier/debugprint.nvim',
  'mawkler/demicolon.nvim',
  -- 'jinh0/eyeliner.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Autoclose
  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    cond = conds['windwp/nvim-autopairs'] or false,
    opts = {},
  },
  -- Todo comments
  {
    'nishantpillai5/todo-comments.nvim', -- WARN: Circular todos not merged, using my fork
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = require('config.todo_comments').keys,
    cond = conds['folke/todo-comments.nvim'] or false,
    config = require('config.todo_comments').config,
  },
  -- Tmux like navigation
  {
    'alexghergh/nvim-tmux-navigation',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['alexghergh/nvim-tmux-navigation'] or false,
    keys = require('config.tmux_navigation').keys,
    config = require('config.tmux_navigation').config,
  },
  -- Better undo
  {
    'mbbill/undotree',
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'undotree' },
    },
    cond = conds['mbbill/undotree'] or false,
  },
  -- Better yank
  {
    'gbprod/yanky.nvim',
    -- event = 'VeryLazy',
    cond = conds['gbprod/yanky.nvim'] or false,
    keys = require('config.yanky').keys,
    config = require('config.yanky').config,
  },
  -- Better join
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cond = conds['Wansmer/treesj'] or false,
    keys = {
      { '<space>J', "<cmd>lua require('treesj').toggle()<cr>", desc = 'code_join' },
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
    -- event = 'VeryLazy',
    event = { 'BufReadPre', 'BufNewFile' },
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
  -- Add debug logs
  {
    'andrewferrier/debugprint.nvim',
    cond = conds['andrewferrier/debugprint.nvim'] or false,
    cmd = require('config.debugprint').cmd,
    keys = require('config.debugprint').keys,
    config = require('config.debugprint').config,
  },
  -- Repeat ]d
  {
    'mawkler/demicolon.nvim',
    cond = conds['mawkler/demicolon.nvim'] or false,
    keys = {']', '[' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {},
  },
  -- Visualize jumps
  {
    'jinh0/eyeliner.nvim',
    cond = conds['jinh0/eyeliner.nvim'] or false,
    -- keys = { 't', 'f', 'T', 'F' },
    config = function()
      require('eyeliner').setup {
        highlight_on_key = true,
        default_keymaps = false,
        dim = true, -- Optional
        disabled_filetypes = { 'dashboard' },
      }

      local function eyeliner_jump(key)
        local forward = vim.list_contains({ 't', 'f' }, key)
        return function()
          require('eyeliner').highlight { forward = forward }
          return require('demicolon.jump').horizontal_jump(key)()
        end
      end

      local nxo = { 'n', 'x', 'o' }
      local opts = { expr = true }

      vim.keymap.set(nxo, 'f', eyeliner_jump 'f', opts)
      vim.keymap.set(nxo, 'F', eyeliner_jump 'F', opts)
      vim.keymap.set(nxo, 't', eyeliner_jump 't', opts)
      vim.keymap.set(nxo, 'T', eyeliner_jump 'T', opts)
    end,
  },
}
