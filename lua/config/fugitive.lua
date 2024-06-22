local M = {}

M.keymaps = function()
  vim.keymap.set('n', '<leader>gs', function()
    vim.cmd 'Git'
  end, { desc = 'status' })

  vim.keymap.set('n', '<leader>gl', function()
    vim.cmd 'Git log'
  end, { desc = 'log' })
end

M.setup = function()
  local fugitive_augroup = vim.api.nvim_create_augroup('AUGfugitive', {})
  local autocmd = vim.api.nvim_create_autocmd
  autocmd('BufWinEnter', {
    group = fugitive_augroup,
    pattern = '*',
    callback = function()
      if vim.bo.ft ~= 'fugitive' then
        return
      end

      local bufnr = vim.api.nvim_get_current_buf()
      vim.keymap.set('n', '<leader>P', function()
        vim.cmd [[ Git push ]]
      end, { buffer = bufnr, remap = false, desc = 'push' })

      vim.keymap.set('n', '<leader>p', function()
        vim.cmd [[ Git pull --rebase ]]
      end, { buffer = bufnr, remap = false, desc = 'pull' })
    end,
  })
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
