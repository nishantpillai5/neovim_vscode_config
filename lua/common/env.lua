local M = {}

local os_from_env = os.getenv 'OS'
if os_from_env ~= nil and string.match(os_from_env:lower(), 'windows') then
  M.OS = 'windows'
else
  M.OS = 'linux'
end

M.HOME = os.getenv 'HOME'
M.DIR_NOTES = os.getenv 'DIR_NOTES'
M.DIR_NVIM = os.getenv 'DIR_NVIM'
M.GITIGNORE_PREFIX = os.getenv 'GITIGNORE_PREFIX'

M.ALIGN = 'left'
M.GLOBAL_STATUS = false

return M
