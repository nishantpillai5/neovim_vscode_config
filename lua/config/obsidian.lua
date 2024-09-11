local M = {}

M.keys = {
  -- { '<leader>nj', ':ObsidianToday<cr>', desc = 'journal_today' },
  { '<leader>nj', ':ObsidianDailies<cr>', desc = 'journal_list' },
}

M.setup = function()
  local DIR_NOTES = require('common.env').DIR_NOTES
  require('obsidian').setup {
    ui = {
      enable = false,
    },
    workspaces = {
      {
        name = 'notes',
        path = DIR_NOTES,
      },
    },
    templates = {
      folder = 'templates',
      date_format = '%Y.%m.%d.%a',
      time_format = '%H:%M',
    },
    daily_notes = {
      folder = 'journal',
      date_format = '%Y.%m.%d',
      template = 'daily.md',
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
