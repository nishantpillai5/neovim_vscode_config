local M = {}

M.highlightSeparator = function(mode)
  local c = require('vscode.colors').get_colors()
  if mode == 'n' then
    vim.cmd('hi NvimSeparator guifg=' .. c.vscAccentBlue)
  elseif mode == 'i' then
    vim.cmd('hi NvimSeparator guifg=' .. c.vscBlueGreen)
  elseif (mode == 'v') or (mode == 'V') then
    vim.cmd('hi NvimSeparator guifg=' .. c.vscDarkYellow)
  elseif mode == 'c' then
    vim.cmd('hi NvimSeparator guifg=' .. c.vscPink)
  elseif mode == 't' then
    vim.cmd('hi NvimSeparator guifg=' .. c.vscBlueGreen)
  end
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
