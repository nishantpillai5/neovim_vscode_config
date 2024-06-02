local M = {}

M.OS = 'windows'
M.HOME = os.getenv 'HOME'
M.DIR_NOTES = os.getenv 'DIR_NOTES'
M.DIR_NVIM = os.getenv 'DIR_NVIM'
M.ALIGN = 'left'

return M
