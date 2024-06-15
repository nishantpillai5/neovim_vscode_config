local M = {}

local EXCLUDED_FTS = { 'toggleterm', 'harpoon' }
local GLOBAL_STATUS = require('common.env').GLOBAL_STATUS

local unsaved_buffer_alert = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ft = vim.bo[buf].filetype
    if vim.bo[buf].buflisted and vim.bo[buf].modified and not vim.tbl_contains(EXCLUDED_FTS, ft) then
      return '󰽂 '
    end
  end
  return ''
end

local function readonly_alert()
  local buf = vim.api.nvim_win_get_buf(0)
  if vim.bo[buf].readonly then
    return ' '
  end
  return ''
end

M.init = function()
  if GLOBAL_STATUS then
    vim.opt.laststatus = 3
  end
end

M.setup = function()
  require('lualine').setup {
    extensions = { 'nvim-dap-ui' },
    options = {
      globalstatus = GLOBAL_STATUS,
      theme = 'vscode',
      section_separators = { left = '', right = ' ' },
      component_separators = { left = '', right = '' },
      ignore_focus = { 'OverseerList', 'neo-tree', 'vista', 'copilot-chat' },
      disabled_filetypes = {
        statusline = {},
        winbar = { 'toggleterm' },
      },
    },
    sections = {
      lualine_a = {
        'mode',
        'selectioncount',
      },
      lualine_b = {},
      lualine_c = {
        { 'filename', path = 0 },
      },
      lualine_x = {
        'diagnostics',
      },
      lualine_y = {
        'filetype',
        'encoding',
        'fileformat',
      },
      lualine_z = {
        'progress',
        'location',
      },
    },
    tabline = {
      lualine_a = { 'branch' },
      lualine_b = {
        { 'filename', path = 1 },
      },
      lualine_c = {
        'diff',
        readonly_alert,
        unsaved_buffer_alert,
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
