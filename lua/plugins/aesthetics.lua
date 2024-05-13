local plugins = {
  "Mofiqul/vscode.nvim",
  "petertriho/nvim-scrollbar",
  "nvim-zh/colorful-winsep.nvim",
  "utilyre/barbecue.nvim",
  "nvimdev/dashboard-nvim",
  "nvim-lualine/lualine.nvim",
  "letieu/harpoon-lualine",
  "lukas-reineke/indent-blankline.nvim",
  "rcarriga/nvim-notify",
  "folke/noice.nvim",
}

local conds = require("common.lazy").get_conds(plugins)

return {
  {
    "Mofiqul/vscode.nvim",
    cond = conds["Mofiqul/vscode.nvim"] or false,
    lazy = false,
    priority = 1000,
    config = function()
      local c = require("vscode.colors").get_colors()
      _G.HighlightSeparator = function(mode)
        -- TODO: Get these values from the colorscheme
        if mode == "n" then
          vim.cmd("hi NvimSeparator guifg=" .. "#0A7ACA")
        elseif mode == "i" then
          vim.cmd("hi NvimSeparator guifg=" .. "#4EC9B0")
        elseif (mode == "v") or (mode == "V") then
          vim.cmd("hi NvimSeparator guifg=" .. "#FFAF00")
        elseif mode == "c" then
          vim.cmd("hi NvimSeparator guifg=" .. "#DDB6F2")
        elseif mode == "t" then
          vim.cmd("hi NvimSeparator guifg=" .. "#4EC9B0")
        end
      end

      vim.api.nvim_create_autocmd({ "ModeChanged" }, {
        callback = function(arg)
          local mode = arg.match:match(".:(%a)")
          _G.HighlightSeparator(mode)
        end,
      })

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
    "petertriho/nvim-scrollbar",
    cond = conds["petertriho/nvim-scrollbar"] or false,
    event = { "BufReadPre" },
    config = function()
      -- TODO: prettier scrollbar
      require("scrollbar").setup()
    end,
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    cond = conds["nvim-zh/colorful-winsep.nvim"] or false,
    event = { "WinNew" },
    config = function()
      require("colorful-winsep").setup({ smooth = false })
      _G.HighlightSeparator("n")
    end,
  },
  {
    "utilyre/barbecue.nvim",
    cond = conds["utilyre/barbecue.nvim"] or false,
    -- event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>zcl", "<cmd>lua require('barbecue.ui').toggle()<cr>", desc = "Visual.Context.lualine" },
    },
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      theme = {
        normal = { bg = "#262626" },
      },
      show_basename = false,
      show_dirname = false,
    },
  },
  {
    "nvimdev/dashboard-nvim",
    cond = conds["nvimdev/dashboard-nvim"] or false,
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
    cond = conds["nvim-lualine/lualine.nvim"] or false,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Custom functions
      local function unsaved_buffer_alert()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_get_option(buf, 'modified') then
              return '󰽂 '
          end
        end
        return ''
      end
      local function readonly_alert()
        local buf = vim.api.nvim_win_get_buf(0)
        if vim.bo[buf].readonly then
           return " "
        end
        return ''
      end
      -- Setup
      require("lualine").setup({
        extensions = { "overseer", "nvim-dap-ui" },
        options = {
          globalstatus = true,
          theme = "vscode",
          section_separators = { left = "", right = " " },
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
            { "filename", path = 1 },
            "diff",
          },
          lualine_x = {
            "diagnostics",
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
        tabline = {
          lualine_b = { "overseer" },
          lualine_c = {
            readonly_alert,
            unsaved_buffer_alert,
            -- {
            --   "buffers",
            --   mode = 4,
            --   symbols = {
            --     alternate_file = "",
            --   },
            -- },
          },
        },
      })
    end,
  },
  {
    "letieu/harpoon-lualine",
    cond = conds["letieu/harpoon-lualine"] or false,
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
    cond = conds["lukas-reineke/indent-blankline.nvim"] or false,
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
    cond = conds["rcarriga/nvim-notify"] or false,
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
    cond = conds["folke/noice.nvim"] or false,
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
}
