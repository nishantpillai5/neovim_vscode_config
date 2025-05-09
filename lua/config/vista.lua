local M = {}

M.keys = {
  { '<leader>es', '<cmd>Vista focus<cr>', mode = 'n', desc = 'symbols' },
  { '<leader>eS', '<cmd>Vista!!<cr>', mode = 'n', desc = 'symbols_close' },
}

M.setup = function()
  vim.g.vista_echo_cursor = 0
  vim.g.vista_echo_cursor_strategy = 'floating_win'
  vim.g.vista_cursor_delay = 1500
  vim.g.vista_sidebar_width = 40
end

M.config = function()
  M.setup()

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'vista',
    callback = function()
      vim.defer_fn(function()
        vim.keymap.set('n', 's', '<cmd>HopChar2<cr>', { buffer = true, desc = 'hop_char', noremap = true })
        vim.keymap.set(
          'n',
          '<leader>s',
          ':<C-U>call vista#Sort()<CR>',
          { buffer = true, desc = 'VISTA_sort', noremap = true }
        )
        vim.keymap.set(
          'n',
          '<leader>p',
          ':<C-U>call vista#cursor#TogglePreview()<CR>',
          { buffer = true, desc = 'VISTA_preview', noremap = true }
        )
      end, 300) -- delay to allow vista to load
    end,
  })
end

-- M.config()

return M
