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
    callback = function(opts)
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

      -- Save cursor position on buffer leave
      vim.api.nvim_create_autocmd('BufLeave', {
        buffer = opts.buf,
        callback = function(opts)
          local cursor_pos = vim.api.nvim_win_get_cursor(0)
          vim.b[opts.buf].vista_cursor_pos = cursor_pos
        end,
      })

      -- Restore cursor position on buffer enter
      vim.api.nvim_create_autocmd('BufEnter', {
        buffer = opts.buf,
        callback = function(opts)
          local cursor_pos = vim.b[opts.buf].vista_cursor_pos
          if cursor_pos then
            vim.api.nvim_win_set_cursor(0, cursor_pos)
          end
        end,
      })
    end,
  })
end

-- M.config()

return M
