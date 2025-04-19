local M = {}

M.highlightSeparator = function(mode)
  local c = require('vscode.colors').get_colors()

  local mode_colors = {
    n = c.vscAccentBlue,
    i = c.vscBlueGreen,
    v = c.vscDarkYellow,
    V = c.vscDarkYellow,
    c = c.vscYellow,
    o = c.vscYellow,
    r = c.vscYellow,
    s = c.vscYellow,
    t = c.vscBlueGreen,
  }

  if mode == 'c' then
    vim.cmd 'redraw'
  end

  vim.cmd('hi NvimSeparator guifg=' .. require('common.utils').get_with_default(mode_colors, mode, c.vscAccentBlue))
end

M.setup = function()
  local c = require('vscode.colors').get_colors()
  require('vscode').setup {
    transparent = true,
    italic_comments = true,
    group_overrides = {
      -- https://github.com/Mofiqul/vscode.nvim/blob/main/lua/vscode/theme.lua
      -- https://github.com/Mofiqul/vscode.nvim/blob/main/lua/vscode/colors.lua
      DiagnosticError = { fg = c.vscRed, bg = c.vscPopupHighlightGray },
      DiagnosticInfo = { fg = c.vscBlue, bg = c.vscPopupHighlightGray },
      DiagnosticHint = { fg = c.vscBlue, bg = c.vscPopupHighlightGray },
      NvimDapVirtualText = { fg = c.vscYellow, bg = c.vscPopupHighlightGray },
      NvimDapVirtualTextError = { fg = c.vscRed, bg = c.vscPopupHighlightGray },
      NvimDapVirtualTextChanged = { fg = c.vscOrange, bg = c.vscPopupHighlightGray },
      BiscuitColor = { fg = c.vscGreen, bg = c.vscPopupHighlightGray },
      DashboardHeader = { fg = c.vscGreen },
    },
  }

  vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
    callback = function(arg)
      local mode = arg.match:match '.:(%a)'
      M.highlightSeparator(mode)
    end,
  })

  vim.cmd.colorscheme 'vscode'
end

M.config = function()
  M.setup()
end

-- M.config()

return M
