local M = {}

local check_var = function(var, default)
  local value = os.getenv(var)
  if value == nil then
    vim.health.warn(var .. ' missing. Defaulted to => "' .. default .. '"')
  else
    vim.health.ok(var .. ' => "' .. value .. '"')
  end
end

local check_env_vars = function()
  vim.health.start 'Checking environment variables'
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
    vim.health.ok('_G.' .. var .. ' is set')
  else
    vim.health.warn('_G.' .. var .. ' is not set')
  end
end

local check_globals = function()
  local globals = {
    internal = {
      'loaded_telescope_extension',
    },
    ui = {
      'LOGO',
    },
    workspace = {
      'workspace_load_on_init',
      'workspace_icon',
      'select_workspace_callback',
      'select_workspace',
      'scope_config_file',
    },
    lsp = {
      'pyright_settings',
      'custom_debug_log',
    },
    git = {
      'main_branch',
      'worktree_create_callback',
      'gitlinker_config',
      'fugitive_create_branch'
    },
    tasks = {
      'filter_build_tasks',
      'filter_run_tasks',
      'task_formatter',
      'run_cmd',
      'build_template',
    },
    others = {
      'fav_dirs',
      'notify_loaded_callback',
    },
  }

  for key, tbl in pairs(globals) do
    vim.health.start('Checking ' .. key .. ' definitions')
    table.sort(tbl)
    for _, var in ipairs(tbl) do
      check_global(var)
    end
  end
end

M.check = function()
  vim.health.start 'NVIM CONFIG report'
  check_env_vars()
  check_globals()
end
return M
