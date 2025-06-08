local M = {}
M.keys_all = {
  { '<leader>s', desc = 'save', vsc_cmd = 'workbench.action.files.save' },
  { '<leader>S', desc = 'save_force', vsc_cmd = 'workbench.action.files.save' },
  { '<leader>x', desc = 'quit', vsc_cmd = 'workbench.action.closeActiveEditor' },
  { '<leader>X', desc = 'buffer_delete', vsc_cmd = 'workbench.action.closeActiveEditor' },
  { '<leader>zv', desc = 'vertical_split', vsc_cmd = 'workbench.action.splitEditorRight' },
  { '<leader>zs', desc = 'horizontal_split', vsc_cmd = 'workbench.action.splitEditorDown' },
  { '<C-Right>', desc = 'vertical_resize_right' },
  { '<C-Left>', desc = 'vertical_resize_left' },
  { '<C-Up>', desc = 'vertical_resize_up' },
  { '<C-Down>', desc = 'horizontal_resize_down' },
  { '<Esc>', desc = 'exit_terminal' },

  { '<leader>eO', desc = 'open_explorer', vsc_cmd = 'revealFileInOS' },
  { '<leader>eyy', desc = 'yank_absolute_path', vsc_cmd = 'copyFilePath' },
  { '<leader>eyY', desc = 'yank_relative_path', vsc_cmd = 'copyRelativeFilePath' },
  { '<leader>eyf', desc = 'yank_filename' },
  { '<leader>eyF', desc = 'yank_folder' },
}

M.keys = require('common.utils').filter_keymap(M.keys_all)
local set_keymap = require('common.utils').get_keymap_setter(M.keys)

-- Editor
set_keymap('n', '<leader>s', ':w<cr>')
set_keymap('n', '<leader>S', ':w!<cr>')
set_keymap('n', '<leader>x', ':q<cr>')
set_keymap('n', '<leader>X', ':bd<cr>')

-- Split
set_keymap('n', '<leader>zv', '<cmd>vs<cr>')
set_keymap('n', '<leader>zs', '<cmd>sp<cr>')

-- Resize vertically with Ctrl-Right and Ctrl-Left
set_keymap('n', '<C-Right>', ':vertical resize +2<cr>')
set_keymap('n', '<C-Left>', ':vertical resize -2<cr>')

-- Resize horizontally with Ctrl-Up and Ctrl-Down
set_keymap('n', '<C-Up>', ':resize -2<cr>')
set_keymap('n', '<C-Down>', ':resize +2<cr>')

-- Exit terminal mode with Esc
set_keymap('t', '<Esc>', '<C-\\><C-n>')

-- Open file in explorer
set_keymap('n', '<leader>eO', function()
  local path = vim.fn.expand '%:p:h'
  vim.notify('Opening: ' .. path)
  require('common.utils').open_explorer(path)
end)

-- Yank filepaths
local names = {
  eyy = '%:p',
  eyY = '%',
  eyf = '%:t',
  eyF = '%:p:h',
}

for key, lookup in pairs(names) do
  set_keymap('n', '<leader>' .. key, function()
    local value = vim.fn.expand(lookup)
    vim.fn.setreg('*', value)
    vim.fn.setreg('+', value)
    vim.notify('Yanked: ' .. value)
  end)
end
return M
