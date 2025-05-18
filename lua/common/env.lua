local M = {}

local nvim_python_paths = {
  windows = '~/.virtualenvs/neovim/Scripts/python.exe',
  linux = '~/.virtualenvs/neovim/bin/python3',
  wsl = '~/.virtualenvs/neovim/bin/python3',
  mac = '~/.virtualenvs/neovim/bin/python3',
}

local vsc_config_paths = {
  windows = '~/AppData/Roaming/Code/User/settings.json',
  linux = '~/.config/Code/User/settings.json',
  wsl = '~/.config/Code/User/settings.json',
  mac = '~/Library/Application Support/Code/User/settings.json',
}

local leet_paths = {
  windows = '~/Documents/work/leet',
  linux = '~/work/leet',
  wsl = '~/work/leet',
  mac = '~/work/leet',
}

local os_from_env = vim.loop.os_uname().sysname
local is_windows = os_from_env:find 'Windows' and true or false
local is_mac = os_from_env == 'Darwin'
local is_linux = os_from_env == 'Linux'
local is_wsl = is_linux and vim.loop.os_uname().release:lower():find 'microsoft' and true or false

if os_from_env ~= nil then
  if is_windows then
    M.OS = 'windows'
  elseif is_mac then
    M.OS = 'mac'
  elseif is_wsl then
    M.OS = 'wsl'
  else
    M.OS = 'linux'
  end
else
  M.OS = 'linux'
end

M.defaults = {
  NVIM_CONTEXT = 'home',
  DIR_NOTES = vim.fn.expand '~/notes',
  DIR_NVIM = vim.fn.expand '~/.config/nvim',
  NVIM_PLUGINS = vim.fn.expand '~/.nvim/local_lazy',
  USER_PREFIX = os.getenv 'USER_PREFIX' or os.getenv 'USERNAME' or 'user',
  NVIM_PYTHON = vim.fn.expand(nvim_python_paths[M.OS]),
  VSC_CONFIG = vim.fn.expand(vsc_config_paths[M.OS]),
  DIR_LEET = vim.fn.expand(leet_paths[M.OS]),
}

local set_env = function(var)
  return os.getenv(var) or M.defaults[var]
end

M.NVIM_CONTEXT = set_env 'NVIM_CONTEXT'
M.DIR_NOTES = set_env 'DIR_NOTES'
M.DIR_NVIM = set_env 'DIR_NVIM'
M.NVIM_PLUGINS = set_env 'NVIM_PLUGINS'
M.NVIM_PYTHON = set_env 'NVIM_PYTHON'
M.VSC_CONFIG = set_env 'VSC_CONFIG'
M.DIR_LEET = set_env 'DIR_LEET'

M.GLOBAL_STATUS = true
M.PANEL_POSITION = 'horizontal' -- horizontal, vertical
M.SCREEN = 'normal' -- normal, widescreen

if M.NVIM_CONTEXT == 'work' then
  M.SCREEN = 'widescreen'
  M.PANEL_POSITION = 'vertical'
elseif M.NVIM_CONTEXT == 'present' then
  M.SCREEN = 'normal'
  M.PANEL_POSITION = 'horizontal'
end

M.PRESENTING = M.NVIM_CONTEXT == 'present'

M.USER_PREFIX = os.getenv 'USER_PREFIX' or os.getenv 'USERNAME' or 'user'
M.TODO_CUSTOM = M.USER_PREFIX:sub(1, 4):upper()

return M
