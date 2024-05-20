local M = {}

M.keymaps = function()
  local dap = require 'dap'
  vim.keymap.set('n', '<F5>', function()
    if vim.fn.filereadable '.vscode/launch.json' then
      require('dap.ext.vscode').load_launchjs(nil, { cppdbg = { 'c', 'cpp' } })
    end
    -- vim.notify("DAP: Continue")
    dap.continue()
  end, { desc = 'Debug.continue/start' })

  vim.keymap.set('n', '<C-F5>', function()
    vim.notify 'DAP: Stop'
    dap.close()
  end, { desc = 'Debug.stop' })

  vim.keymap.set('n', '<F6>', function()
    vim.notify 'DAP: Pause'
    dap.pause()
  end, { desc = 'Debug.pause' })

  vim.keymap.set('n', '<F7>', function()
    vim.notify 'DAP: Step Into'
    dap.step_into()
  end, { desc = 'Debug.step_into' })

  vim.keymap.set('n', '<C-F7>', function()
    vim.notify 'DAP: Step Out'
    dap.step_out()
  end, { desc = 'Debug.step_out' })

  vim.keymap.set('n', '<F8>', function()
    -- vim.notify("DAP: Step Over")
    dap.step_over()
  end, { desc = 'Debug.step_over' })

  vim.keymap.set('n', '<leader>bb', function()
    dap.toggle_breakpoint()
  end, { desc = 'Breakpoint.toggle' })

  vim.keymap.set('n', '<leader>bl', function()
    dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
  end, { desc = 'Breakpoint.toggle_with_log' })

  vim.keymap.set('n', '<leader>[b', function()
    require('goto-breakpoints').prev()
  end, { desc = 'Prev.breakpoint' })

  vim.keymap.set('n', '<leader>]b', function()
    require('goto-breakpoints').next()
  end, { desc = 'Next.breakpoint' })

  -- vim.keymap.set({ "n", "v" }, "<leader>bt", function()
  --   require("dap.ui.widgets").preview()
  -- end)
  vim.keymap.set('n', '<leader>fbb', function()
    require('telescope').extensions.dap.list_breakpoints()
  end, { desc = 'Find.Breakpoint' })

  vim.keymap.set('n', '<leader>fbc', function()
    require('telescope').extensions.dap.configurations()
  end, { desc = 'Find.Breakpoint' })

  vim.keymap.set('n', '<leader>fbv', function()
    require('telescope').extensions.dap.variables()
  end, { desc = 'Find.Breakpoint.variables' })

  vim.keymap.set('n', '<leader>fbf', function()
    require('telescope').extensions.dap.frames()
  end, { desc = 'Find.Breakpoint.frames' })
end

M.setup = function()
  local dap = require 'dap'
  require('dap.ext.vscode').json_decode = require('overseer.json').decode
  require('dap.ext.vscode').load_launchjs()
  require('overseer').patch_dap(true)
  require('nvim-dap-virtual-text').setup {
    only_first_definition = false,
    all_references = true,
  }

  vim.g.dap_virtual_text = true

  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '@error', linehl = '', numhl = '' })
  vim.fn.sign_define('DapLogPoint', { text = '󰰍', texthl = '@error', linehl = '', numhl = '' })

  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = 'C:\\Data\\Other\\cpptools-win64\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
    options = {
      detached = false,
    },
  }

  require('telescope').load_extension 'dap'
end

return M
