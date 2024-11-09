local M = {}

local check_var = function(var, default)
  local value = os.getenv(var)
  if value == nil then
    vim.health.warn(var .. ' missing => "' .. default .. '"')
  else
    vim.health.info(var .. ' => "' .. value .. '"')
  end
end

local check_env_vars = function()
  vim.health.start 'Checking Environment Variables'
  local default = require('common.env').defaults
  local keys = {}

  for key in pairs(default) do
    table.insert(keys, key)
  end

  table.sort(keys)

  for _, key in ipairs(keys) do
    check_var(key, default[key])
  end
end

local check_global = function(var)
  if _G[var] then
    vim.health.info('_G.' .. var .. ' is set')
  else
    vim.health.warn('_G.' .. var .. ' is not set')
  end
end

local check_globals = function()
  local globals = {
    'LOGO',
    -- Internal
    'loaded_telescope_extension',
    -- workspace
    'workspace_load_on_init',
    'workspace_icon',
    'select_workspace_callback',
    'select_workspace',
    'scope_config_file',
    -- LSP
    'pyright_settings',
    -- Git
    'main_branch',
    'worktree_create_callback',
    'gitlinker_config',
    -- Tasks
    'filter_build_tasks',
    'filter_run_tasks',
    'task_formatter',
    'run_cmd',
    'build_template',
    -- Others
    'fav_dirs',
    'notify_loaded_callback',
  }

  table.sort(globals)

  vim.health.start 'Checking Global Variables'
  for _, var in ipairs(globals) do
    check_global(var)
  end
end

M.check = function()
  vim.health.start 'NVIM CONFIG report'
  check_env_vars()
  check_globals()
end
return M
