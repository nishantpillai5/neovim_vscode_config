local M = {}

M.keys = {
  { '<F5>', desc = 'debug_continue/start' },
  { '<C-F5>', desc = 'debug_stop' },
  { '<F6>', desc = 'debug_pause' },
  { '<F7>', desc = 'debug_step_into' },
  { '<C-F7>', desc = 'debug_step_out' },
  { '<F8>', desc = 'debug_step_over' },
  { '[b', desc = 'breakpoint' },
  { ']b', desc = 'breakpoint' },
  { '<leader>fbb', desc = 'breakpoint' },
  { '<leader>fbc', desc = 'configurations' },
  { '<leader>fbv', desc = 'variables' },
  { '<leader>fbf', desc = 'frames' },
  { '<leader>zb', desc = 'debug_virtual' },
  { '<leader>bz', desc = 'virtual_text_toggle' },
}

M.keymaps = function()
  local dap = require 'dap'
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<F5>', function()
    if vim.fn.filereadable '.vscode/launch.json' then
      require('dap.ext.vscode').load_launchjs(nil, { cppdbg = { 'c', 'cpp' } })
    end
    dap.continue()
  end)

  set_keymap('n', '<C-F5>', function()
    vim.notify 'DAP: Stop'
    dap.terminate()
  end)

  set_keymap('n', '<F6>', function()
    vim.notify 'DAP: Pause'
    dap.pause()
  end)

  set_keymap('n', '<F7>', function()
    vim.notify 'DAP: Step Into'
    dap.step_into()
  end)

  set_keymap('n', '<C-F7>', function()
    vim.notify 'DAP: Step Out'
    dap.step_out()
  end)

  set_keymap('n', '<F8>', function()
    dap.step_over()
  end)

  set_keymap('n', '[b', function()
    require('goto-breakpoints').prev()
  end)

  set_keymap('n', ']b', function()
    require('goto-breakpoints').next()
  end)

  set_keymap('n', '<leader>zb', function()
    require('nvim-dap-virtual-text').toggle()
  end)

  set_keymap('n', '<leader>bz', function()
    require('nvim-dap-virtual-text').toggle()
  end)

  set_keymap('n', '<leader>fbb', function()
    require('telescope').extensions.dap.list_breakpoints()
  end)

  set_keymap('n', '<leader>fbc', function()
    require('telescope').extensions.dap.configurations()
  end)

  set_keymap('n', '<leader>fbv', function()
    require('telescope').extensions.dap.variables()
  end)

  set_keymap('n', '<leader>fbf', function()
    require('telescope').extensions.dap.frames()
  end)

  -- set_keymap({ "n", "v" }, "<leader>bt", function()
  --   require("dap.ui.widgets").preview()
  -- end)
end

M.setup = function()
  local dap = require 'dap'
  require('dap.ext.vscode').json_decode = require('overseer.json').decode
  -- require('dap.ext.vscode').load_launchjs()
  require('overseer').patch_dap(true)
  require('nvim-dap-virtual-text').setup {
    only_first_definition = false,
    all_references = true,
  }

  vim.g.dap_virtual_text = true

  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '@error', linehl = '', numhl = '' }) -- alternate icons   
  vim.fn.sign_define('DapLogPoint', { text = '󰰍', texthl = '@error', linehl = '', numhl = '' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = '@error', linehl = '', numhl = '' })

  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = 'OpenDebugAD7.exe',
    options = {
      detached = false,
    },
  }

  require('telescope').load_extension 'dap'
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
