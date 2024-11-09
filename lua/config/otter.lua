local M = {}

M.ft = { 'markdown', 'quarto' }

M.setup = function()
  require('otter').setup {
    buffers = {
      set_filetype = true,
    },
  }

  vim.api.nvim_create_autocmd('FileType', {
    pattern = M.ft,
    callback = function()
      require('otter').activate()
    end,
  })
end

M.config = function()
  M.setup()
end

-- M.config()

return M
