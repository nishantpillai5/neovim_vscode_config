local M = {}

M.keys = {
  { '<leader>iP', desc = 'preview_math' },
}

M.ft = { 'markdown', 'quarto' }

M.keymaps = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = M.ft,
    callback = function()
      vim.keymap.set('n', '<leader>iP', require('nabla').toggle_virt, { desc = 'preview_math(quarto)', silent = true })
    end,
  })
end

M.config = function()
  M.keymaps()
end

return M
