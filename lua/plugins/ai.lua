local plugins = {
  'github/copilot.vim',
  -- 'zbirenbaum/copilot.lua', -- TODO: test lua copilot
  'CopilotC-Nvim/CopilotChat.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  {
    'github/copilot.vim',
    cond = conds['github/copilot.vim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'Copilot',
    config = require('config.copilot').config,
  },
  {
    'zbirenbaum/copilot.lua',
    cond = conds['zbirenbaum/copilot.lua'] or false,
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
        },
      }
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    cond = conds['CopilotC-Nvim/CopilotChat.nvim'] or false,
    branch = 'main',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'github/copilot.vim',
      'vhyrro/luarocks.nvim',
      -- 'zbirenbaum/copilot.lua',
    },
    event = 'InsertEnter',
    keys = require('config.copilot_chat').keys,
    config = require('config.copilot_chat').config,
  },
}
