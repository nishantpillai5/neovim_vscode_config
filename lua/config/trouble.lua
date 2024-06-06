local M = {}

M.use_trouble = function()
  local trouble = require 'trouble'
  -- Check whether we deal with a quickfix or location list buffer, close the window and open the
  -- corresponding Trouble window instead.
  if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
    vim.defer_fn(function()
      vim.cmd.lclose()
      trouble.open 'loclist'
    end, 0)
  else
    vim.defer_fn(function()
      vim.cmd.cclose()
      trouble.open 'quickfix'
    end, 0)
  end
end

M.keymaps = function()
  local trouble = require 'trouble'
  vim.keymap.set('n', '<leader>tt', function()
    trouble.toggle 'last'
  end, { desc = 'Trouble.toggle' })

  vim.keymap.set('n', '<leader>td', function()
    trouble.toggle 'diagnostics'
  end, { desc = 'Trouble.diagnostics' })

  vim.keymap.set('n', '<leader>tq', function()
    trouble.toggle 'quickfix'
  end, { desc = 'Trouble.quickfix' })

  vim.keymap.set('n', '<leader>tl', function()
    trouble.toggle 'loclist'
  end, { desc = 'Trouble.loclist' })

  vim.keymap.set('n', '<leader>tg', function()
    vim.cmd 'Gitsigns setloclist'
  end, { desc = 'Trouble.git' })

  vim.keymap.set('n', '<leader>tL', function()
    trouble.toggle 'lsp'
  end, { desc = 'Trouble.loclist' })

  vim.keymap.set('n', '<leader>tf', function()
    trouble.toggle 'telescope'
  end, { desc = 'Trouble.finder' })

  vim.keymap.set('n', '<leader>j', function()
    trouble.next { skip_groups = true, jump = true }
  end, { desc = 'Next.trouble' })

  vim.keymap.set('n', '<leader>k', function()
    trouble.prev { skip_groups = true, jump = true }
  end, { desc = 'Prev.trouble' })

  vim.keymap.set('n', 'gr', function()
    trouble.toggle 'lsp_references'
  end, { desc = 'references' })
end

M.setup = function()
  require('trouble').setup {}

  -- vim.api.nvim_create_autocmd("FileType", {
  --   pattern = {"qf"},
  --   callback = M.use_trouble
  -- })

  vim.api.nvim_create_autocmd('BufRead', {
    callback = function(ev)
      if vim.bo[ev.buf].buftype == 'quickfix' then
        vim.schedule(function()
          vim.cmd [[cclose]]
          vim.cmd [[Trouble qflist open]]
        end)
      end
    end,
  })
end

return M
