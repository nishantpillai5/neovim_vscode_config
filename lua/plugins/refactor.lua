local plugins = {
  'smjonas/inc-rename.nvim',
  -- 'ThePrimeagen/refactoring.nvim', WARN: not tested
  'nvim-pack/nvim-spectre',
}

local conds = require('common.utils').get_conds_table(plugins)

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
      local set_keymap = require('common.utils').get_keymap_setter()
      set_keymap('n', '<leader>rn', function()
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
    keys = require('config.spectre').keys,
    config = require('config.spectre').config,
  },
}
