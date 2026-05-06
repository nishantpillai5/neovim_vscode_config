local M = {}

M.keys = {
  { '<leader>al', mode = { 'n', 'v' }, desc = 'local_chat' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap({ 'n', 'v' }, '<leader>al', function()
    vim.cmd 'CodeCompanionChat'
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
