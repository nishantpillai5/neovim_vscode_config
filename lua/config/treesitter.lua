local M = {}

M.setup = function()
  require('nvim-treesitter').install {
    'c', 'cpp', 'lua', 'vim', 'vimdoc', 'javascript', 'html', 'python',
    'regex', 'bash', 'markdown', 'markdown_inline', 'json', 'gitignore',
    'properties', 'xml', 'http', 'diff', 'graphql',
    -- 'latex',
  }
end

M.config = function()
  M.setup()
end

return M
