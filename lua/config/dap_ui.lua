local M = {}

M.keymaps = function()
  local dapui = require 'dapui'

  vim.keymap.set('n', '<leader>bt', function()
    dapui.toggle()
  end, { desc = 'Breakpoint.toggle_view' })

  -- TODO: make toggle, also remap K to dap eval instead of hover
  vim.keymap.set('n', '<leader>bK', function()
    dapui.eval(vim.fn.expand '<cWORD>')
  end, { desc = 'Breakpoint.hover' })
end

M.setup = function()
  require('dapui').setup()
end

M.config = function ()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
