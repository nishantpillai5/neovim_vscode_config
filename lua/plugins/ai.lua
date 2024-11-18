local plugins = {
  'github/copilot.vim',
  'CopilotC-Nvim/CopilotChat.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  {
    'github/copilot.vim',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['github/copilot.vim'] or false,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = conds['CopilotC-Nvim/CopilotChat.nvim'] or false,
    dependencies = {
      'vhyrro/luarocks.nvim',
    },
    build = function()
      vim.notify "Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim."
    end,
    keys = require('config.copilot_chat').keys,
    config = require('config.copilot_chat').config,
  },
}
