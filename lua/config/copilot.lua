local M = {}

M.config = function()
  local augroup = vim.api.nvim_create_augroup('copilot-disable-patterns', { clear = true })
  local disable_dirs = {
    require('common.env').DIR_NOTES .. '/*',
    require('common.env').DIR_LEET .. '/*',
  }

  for _, pattern in ipairs(disable_dirs) do
    vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
      group = augroup,
      pattern = '*',
      callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local cwd = vim.fn.getcwd()

        if (bufname == '' and cwd:match('^' .. pattern)) or bufname:match(pattern) then
          vim.defer_fn(function()
            vim.notify('Copilot disabled for ' .. pattern, vim.log.levels.INFO)
            vim.cmd 'Copilot disable'
          end, 0)
        end
      end,
    })
  end

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == 'copilot' then
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        for _, pattern in ipairs(disable_dirs) do
          if bufname:match(pattern) then
            vim.schedule(function()
              vim.lsp.buf_detach_client(args.buf, client.id)
            end)
            break
          end
        end
      end
    end,
  })
end

-- M.config()

return M
