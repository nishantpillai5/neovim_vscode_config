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
  { '<leader>J', desc = 'trouble_next_jump_to_hunk' },
  { '<leader>K', desc = 'trouble_prev_jump_to_hunk' },
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
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>tt', function()
    trouble.toggle 'last'
  end)

  set_keymap('n', '<leader>td', function()
    trouble.toggle 'diagnostics_buffer'
  end)

  set_keymap('n', '<leader>tD', function()
    trouble.toggle 'diagnostics'
  end)

  set_keymap('n', '<leader>tq', function()
    trouble.toggle 'quickfix'
  end)

  set_keymap('n', '<leader>tL', function()
    trouble.toggle 'loclist'
  end)

  set_keymap('n', '<leader>tg', function()
    vim.cmd 'Gitsigns setloclist'
  end)

  set_keymap('n', '<leader>tl', function()
    vim.cmd 'Trouble lsp_all toggle focus=false'
  end)

  set_keymap('n', '<leader>ll', function()
    vim.cmd 'Trouble lsp_all toggle focus=false'
  end)

  set_keymap('n', '<leader>tf', function()
    trouble.toggle 'telescope'
  end)

  set_keymap('n', '<leader>j', function()
    trouble.next { skip_groups = true, jump = true }
  end)

  set_keymap('n', '<leader>k', function()
    trouble.prev { skip_groups = true, jump = true }
  end)

  set_keymap('n', '<leader>J', function()
    trouble.next { skip_groups = true, jump = true }
    vim.wait(200)
    require('gitsigns').nav_hunk 'next'
  end)

  set_keymap('n', '<leader>K', function()
    trouble.prev { skip_groups = true, jump = true }
    vim.wait(200)
    require('gitsigns').nav_hunk 'next'
  end)

  set_keymap('n', '<M-j>', function()
    trouble.next { skip_groups = true, jump = true }
  end)

  set_keymap('n', '<M-k>', function()
    trouble.prev { skip_groups = true, jump = true }
  end)

  set_keymap('n', 'gr', function()
    trouble.toggle 'lsp_references'
  end)
end

M.setup = function()
  require('trouble').setup {
    auto_refresh = false,
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
