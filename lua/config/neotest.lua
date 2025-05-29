local M = {}

M.keys = {
  { '<leader>ii', desc = 'test-run' },
  { '<leader>ei', desc = 'tests' },
  { '<leader>iI', desc = 'test-run_all' },
  { '<leader>ix', desc = 'test-stop' },
  { '<leader>id', desc = 'test-debug' },
  { '<leader>ia', desc = 'test-attach' },
  { '<leader>ip', desc = 'test-preview' },
  { '<leader>io', desc = 'test-open' },
  { ']i', desc = 'test' },
  { '[i', desc = 'test' },
}

M.keymaps = function()
  local neotest = require 'neotest'
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>io', function()
    neotest.output_panel.toggle()
  end)

  set_keymap('n', '<leader>ip', function()
    neotest.output.open { enter = true }
  end)

  set_keymap('n', ']i', function()
    neotest.jump.prev { status = 'failed' }
  end)

  set_keymap('n', '[i', function()
    neotest.jump.next { status = 'failed' }
  end)

  set_keymap('n', '<leader>ei', function()
    neotest.summary.toggle()
  end)

  set_keymap('n', '<leader>ii', function()
    neotest.run.run()
  end)

  set_keymap('n', '<leader>iI', function()
    neotest.run.run(vim.fn.expand '%')
  end)

  set_keymap('n', '<leader>id', function()
    neotest.run.run { strategy = 'dap' }
  end)

  set_keymap('n', '<leader>ix', function()
    neotest.run.stop()
  end)

  set_keymap('n', '<leader>ia', function()
    neotest.run.attach()
  end)
end

M.setup = function()
  ---@diagnostic disable-next-line: missing-fields
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
