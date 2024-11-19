local M = {}

M.array = { '｢', '｣' }

local EXCLUDED_FTS = { 'toggleterm', 'TelescopePrompt' }
local IGNORE_FTS = { 'OverseerList', 'neo-tree', 'vista', 'copilot-chat', 'TelescopePrompt', 'trouble', 'fugitive' }

local unsaved_buffer_alert = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ft = vim.bo[buf].filetype
    if vim.bo[buf].buflisted and vim.bo[buf].modified and not vim.tbl_contains(EXCLUDED_FTS, ft) then
      return '󰽂 '
    end
  end
  return ''
end

local get_array_component = function(n)
  local function array_component()
    if unsaved_buffer_alert() ~= '' then
      return M.array[n]
    end
    return ''
  end
  return array_component
end

local function cwd()
  return vim.fn.getcwd()
end

local function worktree()
  local res, match = vim.fn.FugitiveGitDir():gsub('.*worktrees/', '')
  if match == 1 then
    return ' ' .. res
  else
    return ''
  end
end

M.init = function()
  if require('common.env').GLOBAL_STATUS then
    vim.opt.laststatus = 3
  end
end

M.setup = function()
  require('lualine').setup {
    extensions = { 'nvim-dap-ui' },
    options = {
      globalstatus = require('common.env').GLOBAL_STATUS,
      theme = 'vscode',
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      ignore_focus = IGNORE_FTS,
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
      lualine_b = { cwd },
      lualine_c = { 'branch', worktree },
      lualine_x = { { 'diagnostics', always_visible = false } },
      lualine_y = {
        'encoding',
        'filetype',
        'fileformat',
        { 'fileformat', icons_enabled = false },
      },
      lualine_z = {
        'progress',
        'location',
      },
    },
    tabline = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          'filename',
          path = require('common.env').SCREEN == 'widescreen' and 0 or 1,
          symbols = {
            modified = '●',
            readonly = '',
            directory = '',
          },
        },
        'diff',
      },

      lualine_x = {
        unsaved_buffer_alert,
        get_array_component(1),
        {
          'buffers',
          icons_enabled = false,
          show_modified_status = false,
          symbols = {
            modified = '',
            alternate_file = '',
            directory = '',
          },
          fmt = function(name, context)
            if vim.bo[context.bufnr].modified then
              return name
            else
              return ''
            end
          end,
          cond = function()
            return unsaved_buffer_alert() ~= ''
          end,
        },
        get_array_component(2),
      },
      lualine_y = {
        'searchcount',
      },
      lualine_z = {},
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
