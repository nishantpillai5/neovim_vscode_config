local M = {}

M.CONTEXT = os.getenv 'NVIM_CONTEXT' or 'home' -- work, "home

local os_from_env = os.getenv 'OS'
if os_from_env ~= nil and string.match(os_from_env:lower(), 'windows') then
  M.OS = 'windows'
else
  M.OS = 'linux'
end

M.HOME = os.getenv 'HOME'
M.DIR_NOTES = os.getenv 'DIR_NOTES' or M.HOME .. '/notes'
M.DIR_NVIM = os.getenv 'DIR_NVIM' or M.HOME .. '/.config/nvim'
M.NVIM_PLUGINS = os.getenv 'NVIM_PLUGINS' or M.HOME .. '/.nvim/local_lazy'
M.GITIGNORE_PREFIX = os.getenv 'GITIGNORE_PREFIX'

M.GLOBAL_STATUS = true
M.SIDEBAR_POSITION = 'left' -- left, right
M.PANEL_POSITION = 'horizontal' -- horizontal, vertical
M.FORCE_RIGHT_TASKS_PANEL = true
M.SCREEN = 'normal' -- normal, widescreen

if M.CONTEXT == 'work' then
  M.SCREEN = 'widescreen'
  M.PANEL_POSITION = 'vertical'
end

M.TODO_CUSTOM = 'NISH'

return M
