local M = {}

M.setup = function()
  -- require('nvim-treesitter.install').compilers = { 'zig', 'gcc', 'clang', 'cc', 'cl', vim.NIL }
  ---@diagnostic disable-next-line: missing-fields
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'c',
      'cpp',
      'lua',
      'vim',
      'vimdoc',
      'javascript',
      'html',
      'python',
      'regex',
      'bash',
      'markdown',
      'markdown_inline',
      'json',
      'gitignore',
      'properties',
      'xml',
      'http',
      'diff',
      'graphql',
      'latex',
    },
    sync_install = false,
    -- auto_install = false,
    -- ignore_install = {},
    -- modules = {},
    highlight = { enable = true },
    indent = { enable = true },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
