local plugins = {
  'github/copilot.vim',
  'CopilotC-Nvim/CopilotChat.nvim',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'github/copilot.vim',
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
      { '<leader>cc', desc = 'toggle' },
      { '<leader>cc', mode = 'v', desc = 'chat' },
      { '<leader>ce', mode = { 'n', 'v' }, desc = 'explain' },
      { '<leader>cr', desc = 'reset' },
      { '<leader>cb', desc = 'buffer' },
      { '<leader>cf', mode = { 'n', 'v' }, desc = 'find' },
      { '<leader>fc', mode = { 'n', 'v' }, desc = 'chat' },
    },
    config = require('config.copilot_chat').config,
  },
}
