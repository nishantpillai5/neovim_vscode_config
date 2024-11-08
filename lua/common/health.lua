local M = {}

local check_setup = function()
  return true
end

M.check = function()
  vim.health.start 'NVIM CONFIG report'
  if check_setup() then
    vim.health.ok 'Setup is correct'
  else
    vim.health.error 'Setup is incorrect'
  end
  -- TODO: add checks for deps
  -- do some more checking
  -- ...
end
return M
