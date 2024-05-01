local load_plugin = {}
load_plugin["nvim-treesitter/nvim-treesitter"] = true
-- Context
load_plugin["nvim-treesitter/nvim-treesitter-context"] = true
-- LSP
load_plugin["VonHeikemen/lsp-zero.nvim"] = true
-- Lint
load_plugin["mfussenegger/nvim-lint"] = true
-- Fomatter
load_plugin["stevearc/conform.nvim"] = true
-- AI
load_plugin["github/copilot.vim"] = true
-- Completion
load_plugin["gelguy/wilder.nvim"] = false -- WARN: not tested

return {
  {
    "nvim-treesitter/nvim-treesitter",
    cond = load_plugin["nvim-treesitter/nvim-treesitter"],
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
  -- Context
  {
    "nvim-treesitter/nvim-treesitter-context",
    cond = load_plugin["nvim-treesitter/nvim-treesitter-context"],
    event = { "BufReadPre", "BufNewFile" },
  },
  -- LSP
  {
    "VonHeikemen/lsp-zero.nvim",
    cond = load_plugin["VonHeikemen/lsp-zero.nvim"],
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
      local diagnostics_active = true
      local toggle_diagnostics = function()
        diagnostics_active = not diagnostics_active
        if diagnostics_active then
          vim.diagnostic.show()
        else
          vim.diagnostic.hide()
        end
      end

      vim.keymap.set("n", "<leader>zl", toggle_diagnostics, { desc = "Visual.diagnostics" })

      -- Config
      local lsp_zero = require("lsp-zero")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      -- TODO: cmp <cr> to confirm selection

      lsp_zero.on_attach(function(_, bufnr)
        -- see :help lsp-zero-keybindings to learn the available actions
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false,
          exclude = { "gs" },
        })
        vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr })
      end)

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- "typos_lsp",
          "clangd",
          "pyright",
          "lua_ls",
          "yamlls",
          "jsonls",
          "bashls",
          -- "markdown_oxide",
        },
      })

      require("mason-lspconfig").setup_handlers({
        -- default handler
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,

        -- clangd
        ["clangd"] = function()
          require("lspconfig").clangd.setup({
            on_attach = on_attach,
            capabilities = cmp_nvim_lsp.default_capabilities(),
            cmd = {
              "clangd",
              "--offset-encoding=utf-16",
            },
          })
        end,

        -- Lua
        ["lua_ls"] = function()
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
      })

      -- Completion
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          -- confirm completion
          -- ["<C-y>"] = cmp.mapping.confirm({ select = true }),

          -- scroll up and down the documentation window
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
        }),
      })
    end,
  },
  -- Lint
  {
    "mfussenegger/nvim-lint",
    cond = load_plugin["mfussenegger/nvim-lint"],
    event = "VeryLazy",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        -- markdown = { "markdownlint", },
      }

      -- local lint_augroup = vim.api.nvim_create_autocmd("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        -- group = lint_augroup,
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  -- Fomatter
  {
    "zapling/mason-conform.nvim",
    cond = load_plugin["stevearc/conform.nvim"],
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
    keys = {
      { "<leader>ls", mode = { "n", "v" }, desc = "lsp.format" },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          json = { "prettier" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          ["_"] = { "trim_whitespace" },
        },
      })
      require("mason-conform").setup()

      vim.keymap.set({ "n", "v" }, "<leader>ls", function()
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
  -- AI
  {
    "github/copilot.vim",
    cond = load_plugin["github/copilot.vim"],
    event = { "BufReadPre", "BufNewFile" },
  },
  -- Command completion
  {
    "gelguy/wilder.nvim",
    cond = load_plugin["gelguy/wilder.nvim"],
    event = "VeryLazy",
    config = function()
      local wilder = require("wilder")
      wilder.setup({
        modes = { ":" },
      })

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(wilder.popupmenu_palette_theme({
          border = "rounded",
          max_height = "20%",
          min_height = 0,
          prompt_position = "bottom",
          reverse = 1,
        }))
      )
    end,
  },
}
