local M = {}

M.keys = {
  { '<leader>goc', '<cmd>GitBlameOpenCommitURL<cr>', mode = { 'n', 'v' }, desc = 'commit' },
  { '<leader>gof', '<cmd>GitBlameOpenFileURL<cr>', mode = { 'n', 'v' }, desc = 'file' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  local toggle_virtual_blame = function()
    vim.g.gitblame_display_virtual_text = vim.g.gitblame_display_virtual_text == 0 and 1 or 0
  end

  set_keymap('n', '<leader>gv', toggle_virtual_blame)
  set_keymap('n', '<leader>zg', toggle_virtual_blame)
end

M.setup = function()
  vim.g.gitblame_display_virtual_text = 0
  vim.g.gitblame_date_format = '%r'
  vim.g.gitblame_highlight_group = 'GitSignsCurrentLineBlame'
end

local function blame_text()
  return '' .. require('gitblame').get_current_blame_text()
end

M.lualine = function()
  local git_blame = require 'gitblame'
  local lualineC = require('lualine').get_config().sections.lualine_c or {}
  table.insert(lualineC, { blame_text, cond = git_blame.is_blame_text_available })
  require('lualine').setup { sections = { lualine_c = lualineC } }
end

M.config = function()
  M.setup()
  M.keymaps()
  if require('common.env').SCREEN == 'widescreen' then
    M.lualine()
  end
end

return M
