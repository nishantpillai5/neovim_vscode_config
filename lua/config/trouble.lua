local M = {}

M.keys = {
  { '<leader>tt', desc = 'toggle' },
  { '<leader>td', desc = 'diagnostics' },
  { '<leader>tD', desc = 'diagnostics_global' },
  { '<leader>tq', desc = 'quickfix' },
  { '<leader>tL', desc = 'loclist' },
  { '<leader>tg', desc = 'git' },
  { '<leader>tl', desc = 'lsp' },
  { '<leader>ll', desc = 'lsp' },
  { '<leader>tf', desc = 'finder' },
  { '<leader>j', desc = 'trouble_next' },
  { '<leader>k', desc = 'trouble_prev' },
  { '<M-j>', desc = 'trouble_next' },
  { '<M-k>', desc = 'trouble_prev' },
  { 'gr', desc = 'references' },
}

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
  end, { desc = 'toggle' })

  vim.keymap.set('n', '<leader>td', function()
    trouble.toggle 'diagnostics_buffer'
  end, { desc = 'diagnostics' })

  vim.keymap.set('n', '<leader>tD', function()
    trouble.toggle 'diagnostics'
  end, { desc = 'diagnostics_global' })

  vim.keymap.set('n', '<leader>tq', function()
    trouble.toggle 'quickfix'
  end, { desc = 'quickfix' })

  vim.keymap.set('n', '<leader>tL', function()
    trouble.toggle 'loclist'
  end, { desc = 'loclist' })

  vim.keymap.set('n', '<leader>tg', function()
    vim.cmd 'Gitsigns setloclist'
  end, { desc = 'git' })

  vim.keymap.set('n', '<leader>tl', function()
    vim.cmd 'Trouble lsp_all toggle focus=false'
  end, { desc = 'lsp' })

  vim.keymap.set('n', '<leader>ll', function()
    vim.cmd 'Trouble lsp_all toggle focus=false'
  end, { desc = 'lsp' })

  vim.keymap.set('n', '<leader>tf', function()
    trouble.toggle 'telescope'
  end, { desc = 'finder' })

  vim.keymap.set('n', '<leader>j', function()
    trouble.next { skip_groups = true, jump = true }
  end, { desc = 'trouble_next' })

  vim.keymap.set('n', '<leader>k', function()
    trouble.prev { skip_groups = true, jump = true }
  end, { desc = 'trouble_prev' })

  vim.keymap.set('n', '<leader>J', function()
    trouble.next { skip_groups = true, jump = true }
    vim.wait(200)
    require('gitsigns').nav_hunk 'next'
  end, { desc = 'trouble_next' })

  vim.keymap.set('n', '<leader>K', function()
    trouble.prev { skip_groups = true, jump = true }
    vim.wait(200)
    require('gitsigns').nav_hunk 'next'
  end, { desc = 'trouble_prev' })

  vim.keymap.set('n', '<M-j>', function()
    trouble.next { skip_groups = true, jump = true }
  end, { desc = 'trouble_next' })

  vim.keymap.set('n', '<M-k>', function()
    trouble.prev { skip_groups = true, jump = true }
  end, { desc = 'trouble_prev' })

  vim.keymap.set('n', 'gr', function()
    trouble.toggle 'lsp_references'
  end, { desc = 'references' })
end

M.setup = function()
  require('trouble').setup {
    modes = {
      diagnostics_buffer = {
        mode = 'diagnostics',
        filter = { buf = 0 },
      },
      lsp_all = {
        mode = 'lsp',
      },
    },
  }

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

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
