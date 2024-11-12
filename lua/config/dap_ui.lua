local M = {}

M.keys = {
  { '<leader>bb', desc = 'toggle_view' },
  { '<leader>bK', desc = 'hover' },
  -- { "<leader>bK", "<cmd>lua require('dap.ui.variables').visual_hover()<cr>", mode = "v", desc = "Breakpoint.hover" },
  -- { "<leader>b?", "<cmd>lua require('dap.ui.variables').scopes()<cr>", mode = "v", desc = "Breakpoint.hover" },
}

M.keymaps = function()
  local dapui = require 'dapui'
  local dapui_open = false
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  -- FIXME: keybind not working
  local function toggle_dapui()
    dapui.toggle()
    dapui_open = not dapui_open
    if dapui_open then
      vim.keymap.set('n', 'K', function()
        dapui.eval(vim.fn.expand '<cWORD>')
      end, { desc = 'dap_eval' })
    else
      vim.api.nvim_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<cr>', { noremap = true, silent = true })
    end
  end

  set_keymap('n', '<leader>bb', toggle_dapui)
  set_keymap('n', '<leader>bK', function()
    dapui.eval(vim.fn.expand '<cWORD>')
  end)
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
