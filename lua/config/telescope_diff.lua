local M = {}

M.keys = {
  { '<leader>ed', desc = 'diff_file_current' },
  { '<leader>eD', desc = 'diff_file_select_both' },
}

M.keymaps = function()
  vim.keymap.set('n', '<leader>ed', function()
    require('telescope').extensions.diff.diff_current { hidden = true }
  end, { desc = 'diff_file_current' })

  vim.keymap.set('n', '<leader>eD', function()
    require('telescope').extensions.diff.diff_files { hidden = true }
  end, { desc = 'diff_file_select_both' })
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
