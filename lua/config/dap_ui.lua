local M = {}

M.keys_all = {
  { '<leader>bb', desc = 'toggle_view', vsc_cmd = 'workbench.view.debug' },
  { '<leader>bK', desc = 'hover', vsc_cmd = 'editor.debug.action.showDebugHover' },
  -- { "<leader>bK", "<cmd>lua require('dap.ui.variables').visual_hover()<cr>", mode = "v", desc = "Breakpoint.hover" },
  -- { "<leader>b?", "<cmd>lua require('dap.ui.variables').scopes()<cr>", mode = "v", desc = "Breakpoint.hover" },
}
M.keys = require('common.utils').filter_keymap(M.keys_all)

M.common_keys = {
  { 'K', desc = 'dap_eval' },
}

M.keymaps = function()
  local dapui = require 'dapui'
  local dapui_open = false
  local set_common_keymap = require('common.utils').get_keymap_setter(M.common_keys, { buffer = true })

  local function toggle_dapui()
    dapui.toggle()
    dapui_open = not dapui_open
    vim.notify('dapui_open: ' .. tostring(dapui_open))
    if dapui_open then
      set_common_keymap('n', 'K', function()
        dapui.eval(vim.fn.expand '<cWORD>')
      end)

      set_common_keymap('v', 'K', function()
        dapui.eval(vim.fn.getreg 'v')
      end)
    else
      set_common_keymap('n', 'K', ':lua vim.lsp.buf.hover()<cr>', { desc = 'hover' })
      set_common_keymap('v', 'K', ':lua vim.lsp.buf.hover()<cr>', { desc = 'hover' })
    end
  end

  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
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
