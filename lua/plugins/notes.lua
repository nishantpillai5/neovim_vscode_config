local plugins = {
  'backdround/global-note.nvim',
  'iamcco/markdown-preview.nvim',
  'epwalsh/obsidian.nvim',
  -- 'mpas/marp-nvim',
  'Pocco81/HighStr.nvim',
  'mattn/calendar-vim',
  'nfrid/due.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Global note
  {
    'backdround/global-note.nvim',
    lazy = true,
    cond = conds['backdround/global-note.nvim'] or false,
    keys = require('config.global_note').keys,
    config = require('config.global_note').config,
  },
  -- Preview markdown files
  {
    'iamcco/markdown-preview.nvim',
    lazy = true,
    cond = conds['iamcco/markdown-preview.nvim'] or false,
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    cmd = require('config.markdown_preview').cmd,
    config = require('config.markdown_preview').config,
  },
  -- Notes management
  {
    'epwalsh/obsidian.nvim',
    lazy = true,
    version = '*',
    event = {
      'BufReadPre ' .. require('common.utils').to_unix_path(require('common.env').DIR_NOTES) .. '/**.md',
      'BufNewFile ' .. require('common.utils').to_unix_path(require('common.env').DIR_NOTES) .. '/**.md',
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      -- "preservim/vim-markdown"
    },
    cond = conds['epwalsh/obsidian.nvim'] or false,
    keys = require('config.obsidian').keys,
    config = require('config.obsidian').config,
  },
  -- Presentation
  {
    'mpas/marp-nvim',
    lazy = true,
    cond = conds['mpas/marp-nvim'] or false,
    cmd = { 'MarpToggle', 'MarpStatus' },
    config = function()
      vim.notify 'Marp is enabled'
      require('marp').setup {
        port = 8080,
        wait_for_response_timeout = 30,
        wait_for_response_delay = 1,
      }
    end,
  },
  -- Highlight
  {
    'Pocco81/HighStr.nvim',
    lazy = true,
    cond = conds['Pocco81/HighStr.nvim'] or false,
    keys = require('config.highlight').keys,
    config = require('config.highlight').config,
  },
  -- Calendar
  {
    'mattn/calendar-vim',
    lazy = true,
    event = {
      'BufReadPre ' .. require('common.utils').to_unix_path(require('common.env').DIR_NOTES) .. '/**.md',
      'BufNewFile ' .. require('common.utils').to_unix_path(require('common.env').DIR_NOTES) .. '/**.md',
    },
    cond = conds['mattn/calendar-vim'] or false,
    lazy = true,
    init = require('config.calendar').init,
    cmd = require('config.calendar').cmd,
    config = require('config.calendar').config,
  },
  {
    'NFrid/due.nvim',
    lazy = true,
    event = {
      'BufReadPre *todo*.md',
      'BufReadPre *todo*.txt',
      'BufNewFile *todo*.md',
      'BufNewFile *todo*.txt',
    },
    cond = conds['nfrid/due.nvim'] or false,
    config = function()
      require('due_nvim').setup {
        ft = '*todo*.md,*todo*.txt',
        pattern_start = 'due:',
        pattern_end = '',
      }
    end,
  },
}
