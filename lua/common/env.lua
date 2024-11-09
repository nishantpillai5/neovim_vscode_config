local M = {}

local set_env = function(var)
  return os.getenv(var) or M.defaults[var]
end

local os_from_env = os.getenv 'OS'
if os_from_env ~= nil and string.match(os_from_env:lower(), 'windows') then
  M.OS = 'windows'
else
  M.OS = 'linux'
end

local nvim_python_paths = {
  windows = '~/.virtualenvs/neovim/Scripts/python.exe',
  linux = '~/.virtualenvs/neovim/bin/python3',
}

local vsc_config_paths = {
  windows = '~/AppData/Roaming/Code/User/settings.json',
  linux = '~/.config/Code/User/settings.json',
}

M.defaults = {
  NVIM_CONTEXT = 'home',
  DIR_NOTES = vim.fn.expand '~/notes',
  DIR_NVIM = vim.fn.expand '~/.config/nvim',
  NVIM_PLUGINS = vim.fn.expand '~/.nvim/local_lazy',
  USER_PREFIX = os.getenv 'USER_PREFIX' or os.getenv 'USERNAME' or 'user',
  NVIM_PYTHON = vim.fn.expand(nvim_python_paths[M.OS]),
  VSC_CONFIG = vim.fn.expand(vsc_config_paths[M.OS]),
}

M.NVIM_CONTEXT = set_env 'NVIM_CONTEXT'
M.DIR_NOTES = set_env 'DIR_NOTES'
M.DIR_NVIM = set_env 'DIR_NVIM'
M.NVIM_PLUGINS = set_env 'NVIM_PLUGINS'
M.NVIM_PYTHON = set_env 'NVIM_PYTHON'
M.VSC_CONFIG = set_env 'VSC_CONFIG'

M.GLOBAL_STATUS = true
M.PANEL_POSITION = 'horizontal' -- horizontal, vertical
M.SCREEN = 'normal' -- normal, widescreen

if M.NVIM_CONTEXT == 'work' then
  M.SCREEN = 'widescreen'
  M.PANEL_POSITION = 'vertical'
end

M.USER_PREFIX = os.getenv 'USER_PREFIX' or os.getenv 'USERNAME' or 'user'
M.TODO_CUSTOM = M.USER_PREFIX:sub(1, 4):upper()

return M
