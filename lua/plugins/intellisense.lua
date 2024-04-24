return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "javascript", "html", "python", "markdown" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    event = "VeryLazy",
    branch = "v3.x",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false,
          exclude = { "gs" },
        })
        vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr })
      end)

      -- to learn how to use mason.nvim
      -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "typos_lsp",
          "clangd",
          "markdown_oxide",
          "lua_ls",
          "yamlls",
          "jsonls",
          "bashls",
        },
        handlers = {
          lsp_zero.default_setup,
          clangd = function()
            require("lspconfig").clangd.setup({
              on_attach = on_attach,
              capabilities = cmp_nvim_lsp.default_capabilities(),
              cmd = {
                "clangd",
                "--offset-encoding=utf-16",
              },
            })
          end,
          lua_ls = function()
            require("lspconfig").lua_ls.setup({
              on_init = function(client)
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                  return
                end

                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                  runtime = {
                    version = "LuaJIT", -- (LuaJIT in the case of Neovim)
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
            })
          end,
        },
      })
    end,
  },
  {
    "github/copilot.vim",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "stevearc/conform.nvim",
    keys = {
      { "<leader>p", mode = { "n", "v" }, desc = "format" },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          ["_"] = { "trim_whitespace" },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>p", function()
        require("conform").format({
          lsp_fallback = true,
          async = true,
          timeout_ms = 500,
        }, function()
          require("notify")("Formatted")
        end)
      end)
    end,
  },
}
