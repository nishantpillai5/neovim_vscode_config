local M = {}

M.setup = function()
  require('nvim-treesitter.install').compilers = { 'zig', 'gcc', 'clang', 'cc', 'cl', vim.NIL }
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
      "xml",
      "http",
      "graphql"
    },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  }
end

return M
