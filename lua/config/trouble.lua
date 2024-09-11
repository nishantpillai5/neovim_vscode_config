local M = {}

-- TODO: Trouble default lsp position to right, bind ll to view lsp

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
  { 'gr', desc = 'references' },
  { '<leader>tz', desc = 'test' },
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

  vim.keymap.set('n', '<leader>tz', function()
    trouble.toggle 'test'
  end, { desc = 'test' })

  vim.keymap.set('n', '<leader>tt', function()
    trouble.toggle 'last'
  end, { desc = 'toggle' })

  vim.keymap.set('n', '<leader>td', function()
    -- trouble.toggle 'diagnostics'
    vim.cmd 'Trouble diagnostics toggle filter.buf=0'
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
    vim.cmd 'Trouble newlsp toggle focus=false'
  end, { desc = 'lsp' })

  vim.keymap.set('n', '<leader>ll', function()
    vim.cmd 'Trouble newlsp open focus=false'
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

  vim.keymap.set('n', 'gr', function()
    trouble.toggle 'lsp_references'
  end, { desc = 'references' })
end

M.setup = function()
  -- TODO: preview in the bottom https://github.com/folke/trouble.nvim/blob/main/docs/examples.md#preview-in-a-split-to-the-right-of-the-trouble-list
  require('trouble').setup {
    modes = {
      newlsp = {
        mode = 'lsp',
        preview = { --TODO: not preview
          type = 'split',
          relative = 'win',
          position = 'right',
          size = 0.3,
        },
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
