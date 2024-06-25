local M = {}

local os_from_env = os.getenv 'OS'
if os_from_env ~= nil and string.match(os_from_env:lower(), 'windows') then
  M.OS = 'windows'
else
  M.OS = 'linux'
end

-- TODO: add defaults
M.HOME = os.getenv 'HOME'
M.DIR_NOTES = os.getenv 'DIR_NOTES'
M.DIR_NVIM = os.getenv 'DIR_NVIM'
M.GITIGNORE_PREFIX = os.getenv 'GITIGNORE_PREFIX'
M.NVIM_PLUGINS = os.getenv 'NVIM_PLUGINS'

M.GLOBAL_STATUS = true
M.CONTEXT = 'home' -- work, "home

M.SIDEBAR_POSITION = 'right' -- left, right
M.PANEL_POSITION = 'horizontal' -- horizontal, vertical
M.FORCE_RIGHT_TASKS_PANEL = false
M.SCREEN = 'normal' -- normal, widescreen

return M
