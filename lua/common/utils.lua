_G.main_branch = _G.main_branch or nil

local M = {}

function M.get_keys(t)
  -- vim.tbl_keys doesn't sort
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

function M.get_merge_base(branch)
  if not branch or branch == '' then
    branch = M.get_main_branch()
  end
  return vim.fn.system('git merge-base HEAD ' .. branch):gsub('%s+', '')
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
  -- TODO: get mode from M.keys as well
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
  elseif os == 'linux' then
    vim.fn.jobstart({ 'xdg-open', path }, { detach = true })
  elseif os == 'wsl' then
    vim.fn.jobstart({ 'wsl-open', path }, { detach = true })
  elseif os == 'windows' then
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

function M.get_with_default(t, key, default)
  if t[key] ~= nil then
    return t[key]
  end
  return default
end

return M
