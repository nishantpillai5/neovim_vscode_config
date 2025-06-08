local M = {}

M.keys_all = {
  {
    '<leader>zz',
    "<cmd>lua require('zen-mode').toggle()<cr>",
    desc = 'zen',
    vsc_cmd = 'workbench.action.toggleMaximizeEditorGroup',
  },
  {
    '<leader>zZ',
    "<cmd>lua require('zen-mode').toggle({window = { width = 1 }})<cr>",
    desc = 'zen_full',
    vsc_cmd = 'workbench.action.toggleMaximizeEditorGroup',
  },
}
M.keys = require('common.utils').filter_keymap(M.keys_all)

M.setup = function() end

M.config = function() end

-- M.config()

return M
