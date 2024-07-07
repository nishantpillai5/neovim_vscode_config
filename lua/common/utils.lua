local M = {}

function M.get_keys(t)
  local keys={}
  for key,_ in pairs(t) do
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

return M
