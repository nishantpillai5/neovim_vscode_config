local M = {}

M.keys_all = {
  { '<leader>rn', desc = 'rename', vsc_cmd = 'editor.action.refactor' },
}
M.keys = require('common.utils').filter_keymap(M.keys_all)

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>rn', function()
    return ':IncRename ' .. vim.fn.expand '<cword>'
  end, { expr = true })
end

M.setup = function()
  require('inc_rename').setup {}
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
