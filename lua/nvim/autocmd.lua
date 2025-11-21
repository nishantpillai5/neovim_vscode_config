-- Stop insert mode when terminal is closed
vim.api.nvim_create_autocmd('TermClose', {
  pattern = '*',
  callback = function()
    vim.cmd 'stopinsert'
  end,
})

-- Auto enter insert mode when entering a terminal buffer
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    -- Wait briefly just in case we immediately switch out of the buffer
    vim.defer_fn(function()
      if vim.bo.buftype == 'terminal' then
        vim.cmd [[stopinsert]]
        local line_count = vim.api.nvim_buf_line_count(0)
        if line_count > 0 then
          vim.api.nvim_win_set_cursor(0, { line_count, 0 })
        end
      end
    end, 100)
  end,
})

-- Set filetype javascript for strudel
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.str',
  callback = function()
    vim.bo.filetype = 'javascript'
  end,
})
