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
  vim.cmd 'silent! wincmd p'
  vim.cmd('silent! e ' .. get_note_path(day, month, year))
end

local normalize_num = function(num_str)
  return tostring(tonumber(num_str))
end

M.init = function()
  vim.g.calendar_action = 'v:lua.MyCalAction'
  vim.g.calendar_sign = 'v:lua.MyCalSign'
  vim.g.calendar_mark = 'left'
  vim.g.calendar_monday = 1
  vim.g.calendar_datetime = 'title'
  vim.g.calendar_weeknm = 5
  vim.g.calendar_keys = { goto_next_month = '<A-PageDown>', goto_prev_month = '<A-PageUp>' }
  vim.g.calendar_no_mappings = 0
end

M.config = function()
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = require('common.utils').to_unix_path(require('common.env').DIR_NOTES) .. '/journal/*.md',
    callback = function()
      if vim.fn.getcwd() == vim.fn.expand(require('common.env').DIR_NOTES) then
        local filename = vim.fn.expand '%:t'
        local year, month, _ = filename:match '(%d+).(%d+).(%d+).md'
        vim.cmd('silent! Calendar ' .. normalize_num(year) .. ' ' .. normalize_num(month))
        vim.cmd 'silent! wincmd p'
      end
    end,
  })
end

-- M.config()

return M
