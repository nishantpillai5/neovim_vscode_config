local plugins = {
  'backdround/global-note.nvim',
  'iamcco/markdown-preview.nvim',
  'epwalsh/obsidian.nvim',
  -- 'mpas/marp-nvim',
}

local conds = require('common.utils').get_conds_table(plugins)
local NOTES_DIR = require('common.env').DIR_NOTES

return {
  -- Global note
  {
    'backdround/global-note.nvim',
    cond = conds['backdround/global-note.nvim'] or false,
    keys = require('config.global_note').keys,
    config = require('config.global_note').config,
  },
  -- Preview markdown files
  {
    'iamcco/markdown-preview.nvim',
    cond = conds['iamcco/markdown-preview.nvim'] or false,
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    cmd = require("config.markdown_preview").cmd,
    config = require("config.markdown_preview").config,
  },
  -- Notes management
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    -- event = {
    --   "BufReadPre " .. NOTES_DIR .. "/**.md",
    --   "BufNewFile " .. NOTES_DIR .. "/**.md",
    -- },
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- "preservim/vim-markdown"
    },
    cond = conds['epwalsh/obsidian.nvim'] or false,
    keys = require('config.obsidian').keys,
    config = require('config.obsidian').config
    ,
  },
  -- Presentation
  {
    'mpas/marp-nvim',
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
}
