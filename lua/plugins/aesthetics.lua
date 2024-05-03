local load_plugin = {}

load_plugin["Mofiqul/vscode.nvim"] = true
load_plugin["nvimdev/dashboard-nvim"] = true
load_plugin["nvim-lualine/lualine.nvim"] = true
load_plugin["letieu/harpoon-lualine"] = true
load_plugin["lukas-reineke/indent-blankline.nvim"] = true
load_plugin["rcarriga/nvim-notify"] = true
load_plugin["folke/noice.nvim"] = true
load_plugin["levouh/tint.nvim"] = true

return {
  {
    "Mofiqul/vscode.nvim",
    cond = load_plugin["Mofiqul/vscode.nvim"],
    lazy = false,
    priority = 1000,
    config = function()
      local c = require("vscode.colors").get_colors()

      require("vscode").setup({
        italic_comments = true,
        group_overrides = {
          -- TODO: Add more overrides
          -- https://github.com/Mofiqul/vscode.nvim/blob/main/lua/vscode/theme.lua
          -- https://github.com/Mofiqul/vscode.nvim/blob/main/lua/vscode/colors.lua
          DiagnosticError = { fg = c.vscRed, bg = c.vscPopupHighlightGray },
          DiagnosticInfo = { fg = c.vscBlue, bg = c.vscPopupHighlightGray },
          DiagnosticHint = { fg = c.vscBlue, bg = c.vscPopupHighlightGray },
          NvimDapVirtualText = { fg = c.vscYellow, bg = c.vscPopupHighlightGray },
          NvimDapVirtualTextError = { fg = c.vscRed, bg = c.vscPopupHighlightGray },
          NvimDapVirtualTextChanged = { fg = c.vscOrange, bg = c.vscPopupHighlightGray },
          BiscuitColor = { fg = c.vscGreen, bg = c.vscPopupHighlightGray },
        },
      })
      vim.cmd.colorscheme("vscode")
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    cond = load_plugin["nvimdev/dashboard-nvim"],
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    priority = 900,
    config = function()
      require("dashboard").setup({
        theme = "hyper",
        change_to_vcs_root = true,
        config = {
          week_header = {
            enable = true,
          },
          project = { enable = false },
          mru = { cwd_only = true },
          shortcut = {
            {
              desc = "󱇳 Workspace",
              group = "Number",
              action = "lua require('neoscopes').select()",
              key = "w",
            },
            {
              desc = " Files",
              group = "Label",
              action = "Telescope find_files",
              key = "f",
            },
            {
              desc = "󰊳 Update",
              group = "@property",
              action = "Lazy update",
              key = "u",
            },
          },
          footer = {},
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    cond = load_plugin["nvim-lualine/lualine.nvim"],
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function neoscope()
        local status, neoscopes = pcall(require, "neoscopes")
        if not status then
          return "󱇳 No scope selected"
        end

        local current_scope = neoscopes.get_current_scope()
        if current_scope == nil then
          return "󱇳 No scope selected"
        end

        return "󱇳 " .. neoscopes.get_current_scope().name
      end

      local lsp_clients = function()
        local bufnr = vim.api.nvim_get_current_buf()

        local clients = vim.lsp.buf_get_clients(bufnr)
        if next(clients) == nil then
          return "LSP:"
        end

        local c = {}
        for _, client in pairs(clients) do
          table.insert(c, client.name)
        end
        return "LSP: " .. table.concat(c, ",")
      end

      local lint_progress = function()
        local linters = require("lint").get_running()
        if #linters == 0 then
          return "Lint:" .. table.concat(linters, ", ")
        end
        return "Lint: " .. table.concat(linters, ", ")
      end

      local function harpoon_indicator(harpoon_entry)
        local harpoon_file_path = harpoon_entry.value
        local file_name = harpoon_file_path == "" and "(empty)" or vim.fn.fnamemodify(harpoon_file_path, ":t")
        return file_name
      end

      require("lualine").setup({
        extensions = { "overseer", "nvim-dap-ui" },
        options = {
          globalstatus = true,
          theme = "vscode",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          ignore_focus = { "OverseerList", "neo-tree", "vista", "copilot-chat" },
          disabled_filetypes = {
            statusline = {},
            winbar = { "toggleterm" },
          },
        },
        sections = {
          lualine_a = {
            "mode",
            "selectioncount",
          },
          lualine_b = {
            "branch",
          },
          lualine_c = {
            "harpoon2",
            { "filename", path = 1 },
            "diff",
          },
          lualine_x = {
            "overseer",
            "diagnostics",
            neoscope,
            lint_progress,
            lsp_clients,
          },
          lualine_y = {
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_z = {
            "progress",
            "location",
          },
        },
        winbar = {
          lualine_a = {
            {
              "harpoon2",
              _separator = " | ",
              indicators = { "1", "2", "3", "4" },
              active_indicators = {
                harpoon_indicator,
                harpoon_indicator,
                harpoon_indicator,
                harpoon_indicator,
              },
            },
          },
          lualine_b = {},
          lualine_c = {
            {
              "buffers",
              mode = 4,
              symbols = {
                alternate_file = "",
              },
            },
          },
        },
      })
    end,
  },
  {
    "letieu/harpoon-lualine",
    cond = load_plugin["letieu/harpoon-lualine"],
    event = "VeryLazy",
    dependencies = {
      {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
      },
    },
  },
  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    cond = load_plugin["lukas-reineke/indent-blankline.nvim"],
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "HiPhish/rainbow-delimiters.nvim" },
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require("ibl.hooks")
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup({
        scope = { highlight = highlight },
        exclude = {
          filetypes = { "dashboard" },
        },
      })

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "rcarriga/nvim-notify",
    cond = load_plugin["rcarriga/nvim-notify"],
    event = "VeryLazy",
    config = function()
      require("notify").setup({
        stages = "fade",
        timeout = 3000,
        render = "compact",
      })
      vim.notify = require("notify")
    end,
  },
  {
    "folke/noice.nvim",
    cond = load_plugin["folke/noice.nvim"],
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "VonHeikemen/lsp-zero.nvim",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        presets = {
          bottom_search = false,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        },
      })

      vim.keymap.set("n", "<leader>zn", function()
        require("noice").cmd("disable")
      end, { desc = "Visual.notifications_disable" })
    end,
  },
  {
    "levouh/tint.nvim",
    cond = load_plugin["levouh/tint.nvim"],
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      saturation = 0.2,
    },
  },
}
