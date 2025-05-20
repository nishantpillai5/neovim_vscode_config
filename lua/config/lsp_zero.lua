_G.pyright_settings = _G.pyright_settings or nil

local M = {}

M.keys = {
  { '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', mode = { 'n', 'v' }, desc = 'action(F4)' },
  { '<leader>lS', '<cmd>lua vim.lsp.buf.format()<CR>', mode = { 'n', 'v' }, desc = 'format_with_lsp(F3)' },
  { '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', mode = { 'n', 'v' }, desc = 'rename(F2)' },
  { '<leader>rl', '<cmd>lua vim.lsp.buf.rename()<CR>', mode = { 'n', 'v' }, desc = 'rename_with_lsp(F2)' },
  { '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', mode = { 'n', 'v' }, desc = 'hints_view(K)' },
  { '<leader>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', mode = { 'n', 'v' }, desc = 'diagnostic_view(gl)' },
  { '<leader>lx', desc = 'refresh' },
  { '<leader>lD', desc = 'diagnostics_toggle' },
  { '<leader>lH', desc = 'hints_toggle' },
}

M.keymaps = function()
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

  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>lD', toggle_diagnostics)
  set_keymap('n', '<leader>lH', toggle_hints)

  set_keymap('n', '<leader>lx', function()
    local client = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })[1]
    vim.cmd('LspRestart ' .. client.id)
    vim.notify('LSP restarted: ' .. client.name)
  end)
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

  local lspconfig_defaults = require('lspconfig').util.default_config
  local capabilities =
    vim.tbl_deep_extend('force', lspconfig_defaults.capabilities, cmp_nvim_lsp.default_capabilities())

  require('mason').setup {}
  require('mason-lspconfig').setup {
    automatic_enable = true,
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
    handlers = {
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
          settings = vim.tbl_deep_extend('force', {}, _G.pyright_settings),
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
            if client.workspace_folders and client.workspace_folders[1] then
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
            end
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
    },
  }

  -- Completion
  local cmp = require 'cmp'
  cmp.setup {
    enabled = function()
      return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
    end,
    mapping = cmp.mapping.preset.insert {
      ['<CR>'] = cmp.mapping.confirm { select = true },
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      {
        name = 'lazydev',
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      },
    }, {
      { name = 'buffer' },
    }),
  }

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'cmdline_history' },
      { name = 'buffer' },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'cmdline_history' },
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }),
    ---@diagnostic disable-next-line: missing-fields
    matching = { disallow_symbol_nonprefix_matching = false },
  })

  cmp.setup.cmdline('@', {
    sources = {
      { name = 'cmdline_history' },
    },
  })

  require('cmp').setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
    sources = {
      { name = 'dap' },
    },
  })

  require('luasnip.loaders.from_vscode').lazy_load()
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
    if require('common.env').SCREEN == 'widescreen' then
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
