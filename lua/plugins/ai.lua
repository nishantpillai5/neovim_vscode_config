local plugins = {
  'ggml-org/llama.vim',
  'coder/claudecode.nvim',
  -- 'nickjvandyke/opencode.nvim',
  'olimorris/codecompanion.nvim',
  -- 'github/copilot.vim',
  -- 'zbirenbaum/copilot.lua',
  -- 'CopilotC-Nvim/CopilotChat.nvim',
}

local conds = require('common.utils').get_conds_table(plugins)

return {
  -- Code completion
  {
    'ggml-org/llama.vim',
    cond = conds['ggml-org/llama.vim'] or false,
    event = 'VeryLazy',
    init = function()
      vim.g.llama_config = {
        show_info = false,
        keymap_fim_accept_line = '<Tab>',
        keymap_fim_accept_full = '<S-Tab>',
        -- keymap_inst_accept = '<C-a>',
        -- Disable llama's <leader>ll* maps so <leader>ll stays free (reload_file).
        keymap_fim_trigger = '',
        keymap_fim_accept_word = '',
        keymap_inst_trigger = '',
        keymap_inst_rerun = '',
        keymap_inst_continue = '',
        keymap_debug_toggle = '',
      }
    end,
  },
  -- CLI tool
  {
    'coder/claudecode.nvim',
    lazy = true,
    cond = conds['coder/claudecode.nvim'] or false,
    dependencies = { 'folke/snacks.nvim' },
    cmd = 'ClaudeCode',
    keys = require('config.claude').keys,
    config = require('config.claude').config,
  },
  {
    'nickjvandyke/opencode.nvim',
    lazy = true,
    version = '*',
    cond = conds['nickjvandyke/opencode.nvim'] or false,
    dependencies = {
      {
        'folke/snacks.nvim',
        optional = true,
        opts = {
          input = {}, -- Enhances `ask()`
          picker = { -- Enhances `select()`
            actions = {
              opencode_send = function(...)
                return require('opencode').snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
              },
            },
          },
        },
      },
    },
    config = require('config.opencode').config,
  },
  -- Chat
  {
    'olimorris/codecompanion.nvim',
    cond = conds['olimorris/codecompanion.nvim'] or false,
    version = '^19.0.0',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = require('config/codecompanion').config,
  },
  -- Old stuff
  {
    'github/copilot.vim',
    lazy = true,
    cond = conds['github/copilot.vim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'Copilot',
    keys = require('config.copilot').keys,
    config = require('config.copilot').config,
  },
  {
    'zbirenbaum/copilot.lua',
    lazy = true,
    cond = conds['zbirenbaum/copilot.lua'] or false,
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = '<Tab>',
          },
        },
      }
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    lazy = true,
    cond = conds['CopilotC-Nvim/CopilotChat.nvim'] or false,
    event = 'InsertEnter',
    branch = 'main',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'github/copilot.vim',
      -- 'vhyrro/luarocks.nvim',
      -- 'zbirenbaum/copilot.lua',
    },
    keys = require('config.copilot_chat').keys,
    config = require('config.copilot_chat').config,
  },
}
