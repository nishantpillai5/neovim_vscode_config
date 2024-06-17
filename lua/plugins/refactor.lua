local plugins = {
  'smjonas/inc-rename.nvim',
  -- 'ThePrimeagen/refactoring.nvim', WARN: not tested
  'nvim-pack/nvim-spectre',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  -- Refactor
  {
    'smjonas/inc-rename.nvim',
    cond = conds['smjonas/inc-rename.nvim'] or false,
    keys = {
      { '<leader>rn', desc = 'rename' },
    },
    config = function()
      require('inc_rename').setup()
      vim.keymap.set('n', '<leader>rn', function()
        return ':IncRename ' .. vim.fn.expand '<cword>'
      end, { expr = true })
    end,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    cond = conds['ThePrimeagen/refactoring.nvim'] or false,
    keys = {
      { '<leader>rr', desc = 'refactor' },
    },
    opts = {},
  },
  -- Find and replace
  {
    'nvim-pack/nvim-spectre',
    cond = conds['nvim-pack/nvim-spectre'] or false,
    keys = {
      { '<leader>r/', desc = 'local' },
      { '<leader>r?', desc = 'global' },
      { '<leader>rw', desc = 'global_word' },
    },
    config = require('config.spectre').config,
  },
}
