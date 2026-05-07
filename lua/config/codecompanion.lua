local M = {}

M.keys = {
  { '<leader>cc', mode = { 'n', 'v' }, desc = 'chat' },
  { '<leader>cl', mode = { 'n', 'v' }, desc = 'inline_chat' },
  { '<leader>c;', mode = { 'n', 'v' }, desc = 'cmd' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap({ 'n', 'v' }, '<leader>cc', function()
    vim.cmd 'CodeCompanionChat'
  end)

  set_keymap({ 'n', 'v' }, '<leader>cl', function()
    vim.cmd 'CodeCompanion'
  end)

  set_keymap({ 'n', 'v' }, '<leader>c;', function()
    local prompt = vim.fn.input 'Enter custom prompt: '
    if prompt ~= '' then
      vim.cmd('CodeCompanionCmd ' .. prompt)
    end
  end)
end

M.setup = function()
  require('codecompanion').setup {
    adapters = {
      http = {
        ['llama-server'] = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = {
              url = 'http://localhost:8012',
              api_key = 'TERM', -- no auth needed; any non-empty string works
              chat_url = '/v1/chat/completions',
            },
            schema = {
              model = {
                -- this is just a label, it doesn't have to match the actual model name
                -- default = 'unsloth/gemma-4-E4B-it-GGUF',
                default = 'Qwen Coder Next',
              },
            },
          })
        end,
      },
    },
    interactions = {
      chat = { adapter = 'llama-server' },
      inline = { adapter = 'llama-server' },
      cmd = { adapter = 'llama-server' },
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
