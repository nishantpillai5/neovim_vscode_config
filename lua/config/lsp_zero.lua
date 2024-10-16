_G.pyright_settings = _G.pyright_settings or nil

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
  vim.keymap.set({ 'n', 'v' }, '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'action(F4)' })
  vim.keymap.set({ 'n', 'v' }, '<leader>lS', '<cmd>lua vim.lsp.buf.format()<CR>', { desc = 'format_with_lsp(F3)' })
  vim.keymap.set({ 'n', 'v' }, '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'rename(F2)' })

  vim.keymap.set({ 'n', 'v' }, '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'hints_view(K)' })
  vim.keymap.set(
    { 'n', 'v' },
    '<leader>ld',
    '<cmd>lua vim.diagnostic.open_float()<CR>',
    { desc = 'diagnostic_view(gl)' }
  )
  vim.keymap.set('n', '<leader>lD', toggle_diagnostics, { desc = 'diagnostics_toggle' })
  vim.keymap.set('n', '<leader>lH', toggle_hints, { desc = 'hints_toggle' })
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
      -- 'ruff_lsp',
      'lua_ls',
      'yamlls',
      'jsonls',
      'bashls',
      -- "markdown_oxide",
      'ts_ls',
    },
  }

  local capabilities = cmp_nvim_lsp.default_capabilities()

  require('mason-lspconfig').setup_handlers {
    -- default handler
    function(server_name)
      require('lspconfig')[server_name].setup {}
    end,

    -- C
    ['clangd'] = function()
      require('lspconfig').clangd.setup {
        capabilities = capabilities,
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
        capabilities = capabilities,
        settings = _G.pyright_settings or {},
      }
    end,

    -- ['ruff_lsp'] = function()
    --   require('lspconfig').ruff_lsp.setup {
    --     init_options = {
    --       settings = {
    --         args = {},
    --       },
    --     },
    --   }
    -- end,

    -- Lua
    ['lua_ls'] = function()
      require('lspconfig').lua_ls.setup {
        capabilities = capabilities,
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

    ['ts_ls'] = function()
      require('lspconfig').ts_ls.setup {
        capabilities = capabilities,
        -- on_attach = function(client, bufnr)
        -- Disable tsserver formatting if you use another formatter
        -- client.resolved_capabilities.document_formatting = false
        -- end,
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
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      {
        name = 'lazydev',
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    }),
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
    ['ruff_lsp'] = '',
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

  local clients = vim.lsp.get_clients { bufnr = bufnr }
  if next(clients) == nil then
    return '  '
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, get_logo(client.name))
  end

  local array = require('config.lualine').array
  return '  ' .. array[1] .. table.concat(c, ' ') .. ' ' .. array[2]
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
