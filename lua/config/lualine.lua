local M = {}

local excluded_fts = { 'toggleterm', 'harpoon' }

local unsaved_buffer_alert = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if vim.api.nvim_buf_get_option(buf, 'modified') then
      if not vim.tbl_contains(excluded_fts, ft) then
        return '󰽂 '
      end
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

M.setup = function()
  require('lualine').setup {
    extensions = { 'nvim-dap-ui' },
    options = {
      globalstatus = false,
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
      lualine_b = {
        'diff',
      },
      -- lualine_c = {},
      lualine_x = {
        'diagnostics',
      },
      lualine_y = {
        'encoding',
        'fileformat',
        'filetype',
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
        readonly_alert,
        unsaved_buffer_alert,
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  }
end

return M
