local M = {}

M.keys = {
  { '<leader>bb', desc = 'toggle_view' },
  { '<leader>bK', desc = 'hover' },
  -- { "<leader>bK", "<cmd>lua require('dap.ui.variables').visual_hover()<cr>", mode = "v", desc = "Breakpoint.hover" },
  -- { "<leader>b?", "<cmd>lua require('dap.ui.variables').scopes()<cr>", mode = "v", desc = "Breakpoint.hover" },
}

M.keymaps = function()
  local dapui = require 'dapui'

  vim.keymap.set('n', '<leader>bb', function()
    dapui.toggle()
  end, { desc = 'toggle_view' })

  -- TODO: make toggle, also remap K to dap eval instead of hover
  vim.keymap.set('n', '<leader>bK', function()
    dapui.eval(vim.fn.expand '<cWORD>')
  end, { desc = 'hover' })
end

M.setup = function()
  require('dapui').setup()
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
