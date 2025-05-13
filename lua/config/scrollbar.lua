local M = {}

M.setup = function()
  local c = require('vscode.colors').get_colors()
  require('scrollbar').setup {
    handle = {
      color = c.vscPopupHighlightGray,
    },
    marks = {
      Search = { text = { '', '' }, color = c.vscViolet },
      Error = { text = { '', '' }, color = c.vscRed },
      Warn = { text = { '', '' }, color = c.vscOrange },
      Info = { text = { '', '' }, color = c.vscYellow },
      Hint = { text = { '', '' }, color = c.vscYellow },
      Misc = { text = { '-', '=' }, color = c.vscYellow },
      GitAdd = { text = '▌', color = c.vscGreen },
      GitChange = { text = '▌', color = c.vscYellow },
      GitDelete = { text = '▌', color = c.vscRed },
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
