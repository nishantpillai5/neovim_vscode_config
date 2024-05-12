local plugins = {
  "nvim-treesitter/nvim-treesitter",
  -- Context
  "nvim-treesitter/nvim-treesitter-context",
  "code-biscuits/nvim-biscuits",
  -- LSP
  "VonHeikemen/lsp-zero.nvim",
  -- Lint
  "mfussenegger/nvim-lint",
  -- Fomatter
  "stevearc/conform.nvim",
  -- Terminal Completion
  -- "gelguy/wilder.nvim", -- WARN: not tested
  -- Log Highlighting
  "mtdl9/vim-log-highlighting",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    cond = conds["nvim-treesitter/nvim-treesitter"] or false,
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.install').compilers = { 'zig', "gcc", "clang", "cc", "cl", vim.NIL }
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "html",
          "python",
          "regex",
          "bash",
          "markdown",
          "markdown_inline",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  -- Context
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cond = conds["nvim-treesitter/nvim-treesitter-context"] or false,
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "code-biscuits/nvim-biscuits",
    cond = conds["code-biscuits/nvim-biscuits"] or false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "<leader>zcc",
        function()
          local nvim_biscuits = require("nvim-biscuits")
          nvim_biscuits.BufferAttach()
          nvim_biscuits.toggle_biscuits()
        end,
        mode = "n",
        desc = "Visual.Context.virtual",
      },
    },
    opts = {
      default_config = {
        prefix_string = "  ",
      },
    },
  },
  -- LSP
  {
    "VonHeikemen/lsp-zero.nvim",
    cond = conds["VonHeikemen/lsp-zero.nvim"] or false,
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
            -- on_attach = on_attach,
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
            capabilities = cmp_nvim_lsp.default_capabilities(),
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
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
        }),
      })

      -- Lualine
      local get_logo = function (name)
        local logo_dict = {
          ["lua_ls"] = "󰢱",
          ["GitHub Copilot"] = "",
          ["clangd"] = "󰙱",
          ["pyright"] = "",
        }
        local icon = logo_dict[name]
        if icon == nil then
            return name
        end

        return icon
      end

      local lsp_clients = function()
        local bufnr = vim.api.nvim_get_current_buf()

        local clients = vim.lsp.buf_get_clients(bufnr)
        if next(clients) == nil then
          return "  "
        end

        local c = {}
        for _, client in pairs(clients) do
          table.insert(c, get_logo(client.name))
        end
        return "  " .. table.concat(c, " ")
      end

      local lualineX = require("lualine").get_config().sections.lualine_x or {}
      table.insert(lualineX, { lsp_clients })

      require("lualine").setup({
        sections = { lualine_x = lualineX },
      })
    end,
  },
  -- Lint
  {
    "mfussenegger/nvim-lint",
    cond = conds["mfussenegger/nvim-lint"] or false,
    event = "VeryLazy",
    dependencies = {"VonHeikemen/lsp-zero.nvim"},
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        -- c = { "cppcheck" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          require("lint").try_lint()
        end,
      })

      -- Lualine
      local lint_progress = function()
        local linters = require("lint").get_running()
        if #linters == 0 then
          return "  " .. table.concat(linters, ", ")
        end
        return "  " .. table.concat(linters, ", ")
      end

      local lualineX = require("lualine").get_config().sections.lualine_x or {}
      local index = #lualineX == 0 and 1 or #lualineX
      table.insert(lualineX, index, { lint_progress })

      require("lualine").setup({
        sections = { lualine_x = lualineX },
      })

    end,
  },
  -- Fomatter
  {
    "zapling/mason-conform.nvim",
    cond = conds["stevearc/conform.nvim"] or false,
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
    keys = {
      { "<leader>ls", mode = { "n", "v" }, desc = "LSP.format" },
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
          vim.notify("Formatted")
        end)
      end)
    end,
  },
  -- Command completion
  {
    "gelguy/wilder.nvim",
    cond = conds["gelguy/wilder.nvim"] or false,
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
  -- Log Highlighting
  {
    "mtdl9/vim-log-highlighting",
    cond = conds["mtdl9/vim-log-highlighting"] or false,
    event = { "BufReadPre *.log", "BufNewFile *.log" },
    config = function()

  -- TODO: create syntax for [filename.c(1234)]
  -- vim.api.nvim_create_autocmd({ "Syntax" }, {
  --   -- pattern = { "*.log" },
  --   callback = function()
  --     vim.cmd("syn match logLevelError /\\[.*\\.c\\(*/")
  --   end,
  -- })

    end,
  },
}
