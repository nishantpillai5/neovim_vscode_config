local M = {}

local IS_WIDESCREEN = require('common.env').SCREEN == 'widescreen'

local toggle_hints = function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

local toggle_diagnostics = function()
  local current_config = vim.diagnostic.config()
  if current_config ~= nil then
    local current_virtual_text = current_config.virtual_text or false
    vim.diagnostic.config { virtual_text = not current_virtual_text, signs = false }
  end
end

M.keymaps = function()
  vim.keymap.set('n', '<leader>zl', toggle_hints, { desc = 'toggle_hints' })
  vim.keymap.set('n', '<leader>zL', toggle_diagnostics, { desc = 'toggle_diagnostics' })
end

M.setup = function()
  vim.diagnostic.config { virtual_text = true, signs = false }
  vim.lsp.inlay_hint.enable()

  local lsp_zero = require 'lsp-zero'
  local cmp_nvim_lsp = require 'cmp_nvim_lsp'

  lsp_zero.on_attach(function(_, bufnr)
    -- see :help lsp-zero-keybindings to learn the available actions
    lsp_zero.default_keymaps {
      buffer = bufnr,
      preserve_mappings = false,
      exclude = { 'gr' },
    }
  end)

  require('mason').setup {}
  require('mason-lspconfig').setup {
    ensure_installed = {
      -- "typos_lsp",
      'clangd',
      'pyright',
      'lua_ls',
      'yamlls',
      'jsonls',
      'bashls',
      -- "markdown_oxide",
    },
  }

  require('mason-lspconfig').setup_handlers {
    -- default handler
    function(server_name)
      require('lspconfig')[server_name].setup {}
    end,

    -- C
    ['clangd'] = function()
      require('lspconfig').clangd.setup {
        capabilities = cmp_nvim_lsp.default_capabilities(),
        cmd = {
          'clangd',
          '--offset-encoding=utf-16',
          '--background-index',
        },
      }
    end,

    -- Python
    ['pyright'] = function()
      require('lspconfig').pyright.setup {
        capabilities = cmp_nvim_lsp.default_capabilities(),
        settings = _G.pyright_settings or {},
      }
    end,

    -- Lua
    ['lua_ls'] = function()
      require('lspconfig').lua_ls.setup {
        capabilities = cmp_nvim_lsp.default_capabilities(),
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT', -- (LuaJIT in the case of Neovim)
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      }
    end,
  }

  -- Completion
  local cmp = require 'cmp'
  cmp.setup {
    mapping = cmp.mapping.preset.insert {
      ['<CR>'] = cmp.mapping.confirm { select = true },
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
    },
  }

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })
end

local get_logo = function(name)
  local logo_dict = {
    ['lua_ls'] = '󰢱',
    ['GitHub Copilot'] = '',
    ['clangd'] = '󰙱',
    ['pyright'] = '',
    ['jsonls'] = '',
  }
  local icon = logo_dict[name]
  if icon then
    if IS_WIDESCREEN then
      return icon .. ' ' .. name
    end
    return icon
  end

  return name
end

local lsp_clients = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.buf_get_clients(bufnr)
  if next(clients) == nil then
    return '  '
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, get_logo(client.name))
  end

  if IS_WIDESCREEN then
    return '  [' .. table.concat(c, ' ') .. ']'
  end

  return '  ' .. table.concat(c, ' ')
end

M.lualine = function()
  local lualineX = require('lualine').get_config().sections.lualine_x or {}
  table.insert(lualineX, { lsp_clients })
  require('lualine').setup { sections = { lualine_x = lualineX } }
end

M.config = function()
  M.setup()
  M.keymaps()
  M.lualine()
end

-- M.config()

return M
