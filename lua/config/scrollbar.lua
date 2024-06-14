local M = {}

M.setup = function()
  local c = require('vscode.colors').get_colors()
  require('scrollbar').setup {
    handle = {
      color = c.vscPopupHighlightGray,
    },
    marks = {
      Search = { color = c.vscViolet },
      Error = { color = c.vscRed },
      Warn = { color = c.vscOrange },
      Info = { color = c.vscYellow },
      Hint = { color = c.vscYellow },
      Misc = { color = c.vscYellow },
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
