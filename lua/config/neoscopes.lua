_G.scope_config_file = _G.scope_config_file or nil
_G.select_workspace_callback = _G.select_workspace_callback or nil
_G.select_workspace = _G.select_workspace or nil
_G.workspace_load_on_init = _G.workspace_load_on_init or nil
_G.workspace_icon = _G.workspace_icon or nil

local M = {}
local icon = ' '
local SILENT = true

M.keys = {
  { '<leader>ww', desc = 'select_scope' },
  { '<leader>wx', desc = 'close_scope' },
}

M.common_keys = {
  { '<leader>ff', desc = 'find_files(workspace)' },
  { '<leader>fA', desc = 'find_alternate(workspace)' },
  { '<leader>fl', desc = 'live_grep(workspace)' },
  { '<leader>fL', desc = 'live_grep_args(workspace)' },
  { '<leader>fw', desc = 'grep_word(workspace)' },
  { '<leader>fW', desc = 'grep_whole_word(workspace)' },
  { '<leader>?', desc = 'grep_string(workspace)' },
}

local global_scopes = function()
  local neoscopes = require 'neoscopes'
  ---@diagnostic disable-next-line: missing-fields
  neoscopes.add { name = 'notes', dirs = { require('common.env').DIR_NOTES } }
  ---@diagnostic disable-next-line: missing-fields
  neoscopes.add { name = 'nvim_config', dirs = { require('common.env').DIR_NVIM } }
end

local replace_telescope_keymaps = function()
  local neoscopes = require 'neoscopes'

  local set_keymap = require('common.utils').get_keymap_setter(M.common_keys)

  set_keymap('n', '<leader>ff', function()
    require('telescope.builtin').find_files {
      prompt_prefix = icon .. '> ',
      search_dirs = neoscopes.get_current_dirs(),
    }
  end)

  set_keymap('n', '<leader>fA', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local basename = vim.fn.fnamemodify(bufname, ':t:r'):lower()
    require('telescope.builtin').find_files {
      prompt_prefix = icon .. '> ',
      default_text = basename,
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end)

  set_keymap('n', '<leader>fl', function()
    require('telescope.builtin').live_grep {
      prompt_prefix = icon .. '> ',
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end)

  set_keymap('n', '<leader>fL', function()
    require('telescope').extensions.live_grep_args.live_grep_args {
      prompt_prefix = icon .. '> ',
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end)

  set_keymap('n', '<leader>fw', function()
    local word = vim.fn.expand '<cword>'
    require('telescope.builtin').grep_string {
      prompt_prefix = icon .. '> ',
      search = word,
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end)

  set_keymap('n', '<leader>fW', function()
    local word = vim.fn.expand '<cWORD>'
    require('telescope.builtin').grep_string {
      prompt_prefix = icon .. '> ',
      search = word,
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end)

  set_keymap('n', '<leader>?', function()
    require('telescope.builtin').grep_string {
      prompt_prefix = icon .. '> ',
      search = vim.fn.input 'Search > ',
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end)
end

local refresh_workspace = function()
  local neoscopes = require 'neoscopes'
  local current_scope = neoscopes.get_current_scope()
  if current_scope == nil then
    if not SILENT then
      vim.notify(icon .. 'No scope selected')
    end
    require('config.telescope').keymaps()
  else
    local scope_name = current_scope.name
    if not SILENT then
      vim.notify('Scope selected: ' .. icon .. ' ' .. scope_name)
    end
    replace_telescope_keymaps()
    if _G.select_workspace_callback ~= nil then
      _G.select_workspace_callback(scope_name)
    end
  end
end

M.setup = function(selecting)
  local neoscopes = require 'neoscopes'
  neoscopes.setup {
    neoscopes_config_filename = _G.scope_config_file,
    on_scope_selected = refresh_workspace,
  }
  global_scopes()

  if selecting then
    if _G.select_workspace ~= nil then
      _G.select_workspace()
    else
      neoscopes.select()
    end
  end
end

M.keymaps = function()
  local neoscopes = require 'neoscopes'
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>ww', function()
    M.setup(true)
  end)

  set_keymap('n', '<leader>wx', function()
    neoscopes.clear()
    refresh_workspace()
  end)
end

local function lualine_status()
  local neoscopes = require 'neoscopes'
  local current_scope = neoscopes.get_current_scope()
  if current_scope == nil then
    return icon .. ''
  end
  return icon .. neoscopes.get_current_scope().name
end

M.lualine = function()
  local lualineZ = require('lualine').get_config().tabline.lualine_z or {}
  table.insert(lualineZ, { lualine_status })

  require('lualine').setup { tabline = { lualine_z = lualineZ } }
end

M.config = function()
  if _G.workspace_icon ~= nil then
    icon = _G.workspace_icon
  end

  M.keymaps()
  M.lualine()

  if _G.workspace_load_on_init ~= nil then
    M.setup(_G.workspace_load_on_init)
  else
    M.setup(false)
  end
end

-- M.config()

return M
