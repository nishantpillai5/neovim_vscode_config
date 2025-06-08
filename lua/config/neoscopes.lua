_G.scope_config_file = _G.scope_config_file or nil
_G.select_workspace_callback = _G.select_workspace_callback or nil
_G.select_workspace = _G.select_workspace or nil
_G.workspace_load_on_init = _G.workspace_load_on_init or nil
_G.workspace_icon = _G.workspace_icon or nil

local M = {}
local icon = ' '
local SILENT = true

M.keys_all = {
  { '<leader>ww', desc = 'select_scope', vsc_cmd = 'hqv-mower.select' },
  { '<leader>wx', desc = 'close_scope' },
}
M.keys = require('common.utils').filter_keymap(M.keys_all)

M.common_keys = {
  { '<leader>ff', desc = 'find_files(workspace)' },
  { '<leader>fA', desc = 'find_alternate(workspace)' },
  { '<leader>f/', desc = 'live_grep(workspace)' },
  { '<leader>f?', desc = 'live_grep_args(workspace)' },
  { '<leader>fw', desc = 'grep_word(workspace)' },
  { '<leader>fW', desc = 'grep_whole_word(workspace)' },
  { '<leader>?', desc = 'grep_string(workspace)' },
}

-- FIXME: Telescope keymaps are not replaced
-- key map lazy load doesn't work
-- VeryLazy loading for now
vim.list_extend(M.keys, M.common_keys)

M.constrain_to_scope = function(opts)
  local neoscopes = require 'neoscopes'
  local success, scope = pcall(neoscopes.get_current_scope)
  if not success or not scope then
    -- utils.print('no current scope')
    return opts, {}, {}
  end
  local find_command_opts = {}
  local search_dir_opts = {}
  local pattern = '^file:///'
  for _, dir_name in ipairs(scope.dirs) do
    if dir_name then
      if dir_name:find(pattern) ~= nil then
        table.insert(find_command_opts, '--glob')
        local file_name = dir_name:gsub(pattern, '')
        -- require('user.utils').print(file_name)
        -- table.insert(find_command_opts, string.gsub(dir_name, pattern, ""))
        table.insert(find_command_opts, file_name)
      else
        table.insert(search_dir_opts, dir_name)
      end
    end
  end
  for _, file_name in ipairs(scope.files) do
    if file_name then
      table.insert(find_command_opts, '--glob')
      -- require('user.utils').print('included' .. file_name)
      -- table.insert(find_command_opts, string.gsub(dir_name, pattern, ""))
      table.insert(find_command_opts, file_name)
    end
  end

  opts.prompt_prefix = icon .. '> '
  return opts, find_command_opts, search_dir_opts
end

local global_scopes = function()
  local neoscopes = require 'neoscopes'
  ---@diagnostic disable-next-line: missing-fields
  neoscopes.add { name = 'notes', dirs = { require('common.env').DIR_NOTES } }
  ---@diagnostic disable-next-line: missing-fields
  neoscopes.add { name = 'nvim_config', dirs = { require('common.env').DIR_NVIM } }
end

local replace_telescope_keymaps = function()
  local neoscopes = require 'neoscopes'
  local builtin = require 'telescope.builtin'

  local set_keymap = require('common.utils').get_keymap_setter(M.common_keys)

  set_keymap('n', '<leader>ff', function()
    builtin.find_files {
      prompt_prefix = icon .. '> ',
      search_dirs = neoscopes.get_current_dirs(),
      follow = true,
      no_ignore = true,
    }
  end)

  set_keymap('n', '<leader>fA', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local basename = vim.fn.fnamemodify(bufname, ':t:r'):lower()
    builtin.find_files {
      prompt_prefix = icon .. '> ',
      default_text = basename,
      search_dirs = neoscopes.get_current_dirs(),
      follow = true,
      no_ignore = true,
    }
  end)

  set_keymap('n', '<leader>f/', function()
    builtin.live_grep {
      prompt_prefix = icon .. '> ',
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '-L', '--no-ignore' },
    }
  end)

  set_keymap('n', '<leader>f?', function()
    require('telescope').extensions.live_grep_args.live_grep_args {
      prompt_prefix = icon .. '> ',
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '-L', '--no-ignore' },
    }
  end)

  set_keymap('n', '<leader>fw', function()
    local word = vim.fn.expand '<cword>'
    builtin.grep_string {
      prompt_prefix = icon .. '> ',
      search = word,
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '-L', '--no-ignore' },
    }
  end)

  set_keymap('n', '<leader>fW', function()
    local word = vim.fn.expand '<cWORD>'
    builtin.grep_string {
      prompt_prefix = icon .. '> ',
      search = word,
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '-L', '--no-ignore' },
    }
  end)

  set_keymap('n', '<leader>?', function()
    builtin.grep_string {
      prompt_prefix = icon .. '> ',
      search = vim.fn.input 'Search > ',
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '-L', '--no-ignore' },
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
  ---@diagnostic disable-next-line: missing-fields
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
