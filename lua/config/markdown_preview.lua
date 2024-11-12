local M = {}

local toggle_theme = function()
  if vim.g.mkdp_theme == 'dark' then
    vim.g.mkdp_theme = 'light'
  else
    vim.g.mkdp_theme = 'dark'
  end
  vim.cmd 'MarkdownPreview'
end

M.cmd = {
  'MarkdownPreviewToggle',
  'MarkdownPreview',
  'MarkdownPreviewStop',
  'MarkdownPreviewToggleTheme',
}

M.keys = {
  { '<leader>zp', desc = 'preview' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>zp', function()
    vim.cmd 'MarkdownPreviewToggle'
  end, { buffer = true })
end

M.setup = function()
  vim.g.mkdp_theme = 'dark'
  vim.api.nvim_create_user_command('MarkdownPreviewToggleTheme', toggle_theme, {})
end

M.config = function()
  M.setup()

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = M.keymaps,
  })
end

-- M.config()

return M
