local M = {}

M.use_trouble = function ()
  local trouble = require("trouble")
  -- Check whether we deal with a quickfix or location list buffer, close the window and open the
  -- corresponding Trouble window instead.
  if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
    vim.defer_fn(function()
        vim.cmd.lclose()
        trouble.open("loclist")
    end, 0)
  else
    vim.defer_fn(function()
        vim.cmd.cclose()
        trouble.open("quickfix")
    end, 0)
  end
end

M.keymaps = function()
  local trouble = require 'trouble'
  vim.keymap.set('n', '<leader>tt', function()
    trouble.toggle()
  end, { desc = 'Trouble.toggle' })

  vim.keymap.set('n', '<leader>tw', function()
    trouble.toggle 'workspace_diagnostics'
  end, { desc = 'Trouble.workspace_diagnostics' })

  vim.keymap.set('n', '<leader>td', function()
    trouble.toggle 'document_diagnostics'
  end, { desc = 'Trouble.document_diagnostics' })

  vim.keymap.set('n', '<leader>tq', function()
    trouble.toggle 'quickfix'
  end, { desc = 'Trouble.quickfix' })

  vim.keymap.set('n', '<leader>tl', function()
    trouble.toggle 'loclist'
  end, { desc = 'Trouble.loclist' })

  vim.keymap.set('n', '<leader>tg', function()
    vim.cmd 'Gitsigns setloclist'
  end, { desc = 'Trouble.git' })

  vim.keymap.set('n', '<leader>j', function()
    trouble.next { skip_groups = true, jump = true }
  end, { desc = 'Next.trouble' })

  vim.keymap.set('n', '<leader>k', function()
    trouble.previous { skip_groups = true, jump = true }
  end, { desc = 'Prev.trouble' })

  vim.keymap.set('n', 'gr', function()
    trouble.toggle 'lsp_references'
  end, { desc = 'references' })
end

M.setup = function ()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"qf"},
    callback = M.use_trouble
  })
end

return M
