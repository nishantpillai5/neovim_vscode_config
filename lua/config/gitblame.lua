local M = {}

M.keymaps = function()
  vim.keymap.set('n', '<leader>gv', function()
    vim.g.gitblame_display_virtual_text = vim.g.gitblame_display_virtual_text == 0 and 1 or 0
  end, { desc = 'virtual_blame' })
end

M.setup = function()
  vim.g.gitblame_display_virtual_text = 0
  vim.g.gitblame_date_format = '%r'
  vim.g.gitblame_highlight_group = 'GitSignsCurrentLineBlame'
end

M.lualine = function()
  local git_blame = require 'gitblame'
  local lualineX = require('lualine').get_config().tabline.lualine_x or {}
  table.insert(lualineX, { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available })
  require('lualine').setup { tabline = { lualine_x = lualineX } }
end

M.config = function()
  M.setup()
  M.keymaps()
  if require('common.env').SCREEN == 'widescreen' then
    M.lualine()
  end
end

return M
