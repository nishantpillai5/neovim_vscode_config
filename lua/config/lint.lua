local M = {}

-- TODO: fail quietly

M.setup = function()
  local lint = require 'lint'
  lint.linters_by_ft = {
    c = { 'cppcheck' },
    typescript = { 'eslint_d' },
    javascript = { 'eslint_d' },
  }

  local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })
end

local lint_progress = function()
  local linters = require('lint').get_running()
  local array = require('config.lualine').array
  local linters_string = array[1] .. table.concat(linters, ', ') .. array[2]
  if #linters == 0 then
    return '   '
  end
  return '   ' .. linters_string
end

M.lualine = function()
  local lualineX = require('lualine').get_config().sections.lualine_x or {}
  local index = #lualineX == 0 and 1 or #lualineX
  table.insert(lualineX, index, { lint_progress })

  require('lualine').setup { sections = { lualine_x = lualineX } }
end

M.config = function()
  M.setup()
  M.lualine()
end

-- M.config()

return M
