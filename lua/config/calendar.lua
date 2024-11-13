local M = {}

M.cmd = { 'Calendar', 'CalendarT' }

local function pad(n)
  n = tonumber(n)
  if n < 10 then
    return '0' .. tostring(n)
  else
    return tostring(n)
  end
end

local function get_note_path(day, month, year)
  return require('common.utils').to_unix_path(require('common.env').DIR_NOTES)
    .. '/journal/'
    .. tostring(year)
    .. '.'
    .. pad(month)
    .. '.'
    .. pad(day)
    .. '.md'
end

function MyCalSign(day, month, year)
  if vim.fn.filereadable(get_note_path(day, month, year)) == 1 then
    return 1
  end
  return 0
end

function MyCalAction(day, month, year, _, _)
  vim.cmd 'wincmd p'
  vim.cmd('e ' .. get_note_path(day, month, year))
end

M.init = function()
  vim.g.calendar_action = 'v:lua.MyCalAction'
  vim.g.calendar_sign = 'v:lua.MyCalSign'
  vim.g.calendar_mark = 'left'
  vim.g.calendar_monday = 1
  vim.g.calendar_datetime = 'title'
  vim.g.calendar_weeknm = 5
end

M.config = function()
  vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = require('common.utils').to_unix_path(require('common.env').DIR_NOTES) .. '/journal/*.md',
    callback = function()
      local cwd = vim.fn.getcwd()
      local notes_dir = require('common.env').DIR_NOTES
      if cwd == notes_dir then
        vim.cmd 'Calendar'
        vim.cmd 'wincmd p'
      end
    end,
  })
end

-- M.config()

return M
