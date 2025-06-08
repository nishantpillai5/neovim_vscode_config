local M = {}

M.keys_all = {
  {
    '<leader>u',
    '<cmd>UndotreeToggle<cr>',
    desc = 'undotree',
    vsc_cmd = 'timeline.toggleExcludeSource:timeline.localHistory',
  },
}
M.keys = require('common.utils').filter_keymap(M.keys_all)

-- M.config()

return M
