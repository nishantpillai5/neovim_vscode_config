local plugins = {
  'github/copilot.vim',
  'CopilotC-Nvim/CopilotChat.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'github/copilot.vim',
    tag = "v1.31.0", -- TODO: update when new version if fixed
    cond = conds['github/copilot.vim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    cond = conds['CopilotC-Nvim/CopilotChat.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    build = function()
      vim.notify "Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim."
    end,
    keys = {
      { '<leader>cc', desc = 'Chat.toggle' },
      { '<leader>ce', mode = { 'n', 'v' }, desc = 'Chat.explain' },
      { '<leader>cf', mode = { 'n', 'v' }, desc = 'Chat.fix' },
      { '<leader>cd', mode = { 'n', 'v' }, desc = 'Chat.diagnositic' },
      { '<leader>cr', desc = 'Chat.reset' },
      { '<leader>cb', desc = 'Chat.buffer' },
      { '<leader>cc', mode = 'v', desc = 'Chat.selection' },
    },
    config = function()
      local config = require 'config.ai'
      config.setup()
      config.keymaps()
    end,
  },
}
