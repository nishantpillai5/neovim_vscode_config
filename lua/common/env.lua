local M = {}

M.CONTEXT = os.getenv 'NVIM_CONTEXT' or 'home' -- work, "home

local os_from_env = os.getenv 'OS'
if os_from_env ~= nil and string.match(os_from_env:lower(), 'windows') then
  M.OS = 'windows'
else
  M.OS = 'linux'
end

M.DIR_NOTES = os.getenv 'DIR_NOTES' or vim.fn.expand '~/notes'
M.DIR_NVIM = os.getenv 'DIR_NVIM' or vim.fn.expand '~/.config/nvim'
M.NVIM_PLUGINS = os.getenv 'NVIM_PLUGINS' or vim.fn.expand '~/.nvim/local_lazy'

local nvim_python_paths = {
  windows = '~/.virtualenvs/neovim/Scripts/python.exe',
  linux = '~/.virtualenvs/neovim/bin/python3',
}
M.NVIM_PYTHON = vim.fn.expand(nvim_python_paths[M.OS])

local vsc_config_paths = {
  windows = '~/AppData/Roaming/Code/User/settings.json',
  linux = '~/.config/Code/User/settings.json',
}
M.VSC_CONFIG = os.getenv 'VSC_CONFIG' or vim.fn.expand(vsc_config_paths[M.OS])

M.GLOBAL_STATUS = true
M.PANEL_POSITION = 'horizontal' -- horizontal, vertical
M.SCREEN = 'normal' -- normal, widescreen

if M.CONTEXT == 'work' then
  M.SCREEN = 'widescreen'
  M.PANEL_POSITION = 'vertical'
end

M.USER_PREFIX = os.getenv 'USER_PREFIX' or os.getenv 'USERNAME' or 'user'
M.TODO_CUSTOM = M.USER_PREFIX:sub(1, 4):upper()

return M
