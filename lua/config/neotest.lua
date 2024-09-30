local M = {}

M.keys = {
  { '<leader>ii', desc = 'run' },
  { '<leader>ei', desc = 'tests' },
  { '<leader>if', desc = 'run_file' },
  { '<leader>ix', desc = 'stop' },
  { '<leader>id', desc = 'debug' },
  { '<leader>ia', desc = 'attach' },
  { '<leader>ip', desc = 'preview' },
  { '<leader>io', desc = 'open' },
  { ']i', desc = 'test' },
  { '[i', desc = 'test' },
}

M.keymaps = function()
  local neotest = require 'neotest'

  vim.keymap.set('n', '<leader>io', function()
    neotest.output_panel.toggle()
  end, { desc = 'open' })

  vim.keymap.set('n', '<leader>ip', function()
    neotest.output.open { enter = true }
  end, { desc = 'preview' })

  vim.keymap.set('n', ']i', function()
    neotest.jump.prev { status = 'failed' }
  end, { desc = 'test' })

  vim.keymap.set('n', '[i', function()
    neotest.jump.next { status = 'failed' }
  end, { desc = 'test' })

  vim.keymap.set('n', '<leader>ei', function()
    neotest.summary.toggle()
  end, { desc = 'tests' })

  vim.keymap.set('n', '<leader>ii', function()
    neotest.run.run()
  end, { desc = 'run' })

  vim.keymap.set('n', '<leader>if', function()
    neotest.run.run(vim.fn.expand '%')
  end, { desc = 'run_file' })

  vim.keymap.set('n', '<leader>id', function()
    neotest.run.run { strategy = 'dap' }
  end, { desc = 'debug' })

  vim.keymap.set('n', '<leader>ix', function()
    neotest.run.stop()
  end, { desc = 'stop' })

  vim.keymap.set('n', '<leader>ia', function()
    neotest.run.attach()
  end, { desc = 'attach' })
end

M.setup = function()
  require('neotest').setup {
    adapters = {
      require('neotest-gtest').setup {},
      require 'neotest-python' {
        python = 'C:\\Python\\Python312\\python.exe',
      },
    },
    consumers = {
      overseer = require 'neotest.consumers.overseer',
    },
  }
end

M.lualine = function()
  -- local lualineX = require('lualine').get_config().sections.lualine_x or {}
  -- local index = #lualineX == 0 and 1 or #lualineX
  -- table.insert(lualineX, index, { lint_progress })
  --
  -- require('lualine').setup { sections = { lualine_x = lualineX } }
end

M.config = function()
  M.setup()
  M.keymaps()
  M.lualine()
end

-- M.config()

return M
