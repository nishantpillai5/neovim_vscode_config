_G.main_branch = _G.main_branch or nil

local M = {}

function M.get_keys(t)
  local keys = {}
  for key, _ in pairs(t) do
    table.insert(keys, key)
  end
  table.sort(keys)
  return keys
end

function M.merge_list(t1, t2)
  local new_list = {}
  for _, v in ipairs(t1) do
    table.insert(new_list, v)
  end
  for _, v in ipairs(t2) do
    table.insert(new_list, v)
  end
  return new_list
end

function M.table_has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end

function M.merge_table(t1, t2)
  local result = {}
  for k, v in pairs(t1) do
    result[k] = v
  end
  for k, v in pairs(t2) do
    result[k] = v
  end
  return result
end

function M.deep_copy(object)
  if type(object) ~= 'table' then
    return object
  end

  local result = {}
  for key, value in pairs(object) do
    result[key] = M.deep_copy(value)
  end
  return result
end

function M.spread(template)
  return function(table)
    local result = {}
    for key, value in pairs(template) do
      result[key] = M.deep_copy(value)
    end

    for key, value in pairs(table) do
      result[key] = value
    end
    return result
  end
end

local _orig_root_dir = vim.fn.getcwd()
function M.get_root_dir()
  local root_dir = _orig_root_dir
  local git_dir = require('lspconfig.util').root_pattern '.git'(root_dir)
  if git_dir ~= nil and git_dir ~= '' then
    return git_dir
  end
  return root_dir
end

function M.get_main_branch()
  if _G.main_branch then
    return _G.main_branch
  end

  local get_default_branch = "git rev-parse --symbolic-full-name refs/remotes/origin/HEAD | sed 's!.*/!!'"
  return vim.fn.system(get_default_branch) or 'main'
end

local function get_desc(lhs, table)
  if table == nil or #table == 0 then
    return 'UNKNOWN'
  end
  for _, v in ipairs(table) do
    if v[1] == lhs then
      return v.desc
    end
  end
  return nil
end

function M.get_keymap_setter(keys, setter_opts)
  keys = keys or {}
  setter_opts = setter_opts or {}
  local default_opts = vim.tbl_extend('force', { noremap = true, silent = true }, setter_opts)
  return function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts['desc'] = opts['desc'] or get_desc(lhs, keys)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', default_opts, opts))
  end
end

function M.get_conds_table(plugins_table)
  local load_plugin = {}
  for _, plugin in ipairs(plugins_table) do
    load_plugin[plugin] = true
  end
  return load_plugin
end

function M.starts_with(str, prefix)
  return string.sub(str, 1, #prefix) == prefix
end

-- local run_chars = { '󰖃', '󰜎', '󰑮', '󰜎' }
-- local build_chars = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local build_chars = { '', '' }
local run_chars = { '󰑮', '󰜎' }

function M.spinner(curr_index, char_type)
  local chars = char_type == 'run' and run_chars or build_chars
  local new_index = (curr_index % #chars) + 1
  return chars[new_index], new_index
end

function M.open_explorer(path)
  local os = require('common.env').OS
  if os == 'mac' then
    vim.fn.jobstart({ 'xdg-open', '-g', path }, { detach = true })
  end
  if os == 'linux' then
    vim.fn.jobstart({ 'xdg-open', path }, { detach = true })
  end
  if os == 'windows' then
    vim.cmd('silent !start explorer ' .. path)
  end
end

function M.to_unix_path(path)
  local os = require('common.env').OS
  if os == 'windows' then
    return path:gsub('\\', '/')
  end
  return path
end

return M
