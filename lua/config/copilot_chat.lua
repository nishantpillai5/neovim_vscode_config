local M = {}

M.keymaps = function()
  vim.keymap.set('n', '<leader>cc', function()
    vim.cmd 'CopilotChatToggle'
  end, { desc = 'toggle' })

  vim.keymap.set({ 'n', 'v' }, '<leader>ce', function()
    vim.cmd 'CopilotChatExplain'
  end, { desc = 'explain' })

  vim.keymap.set('n', '<leader>cr', function()
    vim.cmd 'CopilotChatReset'
  end, { desc = 'reset' })

  vim.keymap.set('n', '<leader>cb', function()
    local input = vim.fn.input 'Quick Chat: '
    if input ~= '' then
      require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
    end
  end, { desc = 'buffer' })

  vim.keymap.set('v', '<leader>cc', function()
    local input = vim.fn.input 'Quick Chat: '
    if input ~= '' then
      require('CopilotChat').ask(input, { selection = require('CopilotChat.select').selection })
    end
  end, { desc = 'selection' })

  vim.keymap.set({ 'n', 'v' }, '<leader>fc', function()
    local actions = require 'CopilotChat.actions'
    require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
  end, { desc = 'chat' })

  vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
    local actions = require 'CopilotChat.actions'
    require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
  end, { desc = 'find' })
end

M.setup = function()
  require('CopilotChat').setup {
    show_help = 'yes',
    debug = false,
    disable_extra_info = 'no',
    language = 'English',
    mappings = {
      reset = {
        normal = '<C-r>',
        insert = '<C-r>',
      },
      complete = {
        insert = '<S-Tab>',
      },
    },
  }

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'copilot-*',
    callback = function()
      -- C-p to print last response
      vim.keymap.set('n', '<C-p>', function()
        print(require('CopilotChat').response())
      end, { buffer = true, remap = true })
    end,
  })
end

M.config = function ()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
