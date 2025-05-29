local M = {}

M.keys = {
  { '<leader>iP', desc = 'quarto-preview_math' },
}

M.ft = { 'markdown', 'quarto' }

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  vim.api.nvim_create_autocmd('FileType', {
    pattern = M.ft,
    callback = function()
      set_keymap('n', '<leader>iP', require('nabla').toggle_virt)
    end,
  })
end

M.config = function()
  M.keymaps()
end

return M
