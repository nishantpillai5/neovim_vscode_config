local M = {}

-- FIXME: doesn't work
local toggle_theme = function()
  if vim.g.mkdp_theme == 'dark' then
    vim.g.mkdp_theme = 'light'
  else
    vim.g.mkdp_theme = 'dark'
  end
  vim.cmd('MarkdownPreview')
end

M.cmd  = {
  'MarkdownPreviewToggle',
  'MarkdownPreview',
  'MarkdownPreviewStop',
  'MarkdownPreviewToggleTheme'
}

M.setup = function()
  vim.api.nvim_create_user_command('MarkdownPreviewToggleTheme', toggle_theme, {})
end

M.config = function()
  M.setup()
end

-- M.config()

return M
