local M = {}

M.keys = {
  { '<leader>ls', mode = { 'n', 'v' }, desc = 'format' },
}

M.keymaps = function()
  vim.keymap.set({ 'n', 'v' }, '<leader>ls', function()
    require('conform').format({
      lsp_fallback = true,
      async = true,
      timeout_ms = 500,
    }, function()
      vim.notify 'Formatted'
    end)
  end, { desc = 'format' })
end

M.setup = function()
  require('conform').setup {
    formatters_by_ft = {
      lua = { 'stylua' },
      json = { 'prettier' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      markdown = { 'prettier' },
      ['_'] = { 'trim_whitespace' },
    },
  }
  require('mason-conform').setup()
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
