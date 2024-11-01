-- Editor
vim.keymap.set('n', '<leader>s', ':w<cr>', { silent = true, desc = 'save' })
vim.keymap.set('n', '<leader>S', ':w!<cr>', { silent = true, desc = 'save_force' })
vim.keymap.set('n', '<leader>x', ':q<cr>', { silent = true, desc = 'quit' })
vim.keymap.set('n', '<leader>X', ':bd<cr>', { silent = true, desc = 'buffer_delete' })

-- Split
vim.keymap.set('n', '<leader>zv', '<cmd>vs<cr>', { desc = 'vertical_split' })
vim.keymap.set('n', '<leader>zs', '<cmd>sp<cr>', { desc = 'horizontal_split' })

-- Resize vertically with Ctrl-Right and Ctrl-Left
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<cr>', { silent = true, desc = 'vertical_resize_right' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<cr>', { silent = true, desc = 'vertical_resize_left' })

-- Resize horizontally with Ctrl-Up and Ctrl-Down
vim.keymap.set('n', '<C-Up>', ':resize -2<cr>', { silent = true, desc = 'vertical_resize_up' })
vim.keymap.set('n', '<C-Down>', ':resize +2<cr>', { silent = true, desc = 'horizontal_resize_down' })

-- Exit terminal mode with Esc
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true, desc = 'exit_terminal' })

-- Yank filepaths
local names = {
  eyy = { expand = '%:p', desc = 'absolute_path' },
  eyY = { expand = '%', desc = 'relative_path' },
  eyf = { expand = '%:t', desc = 'filename' },
  eyF = { expand = '%:p:h', desc = 'folder' },
}

for key, lookup in pairs(names) do
  vim.keymap.set('n', '<leader>' .. key, function()
    local value = vim.fn.expand(lookup.expand)
    vim.fn.setreg('*', value)
    vim.fn.setreg('+', value)
    vim.notify('Yanked: ' .. value)
  end, { desc = lookup.desc })
end

vim.keymap.set('n', '<leader>eE', function()
  local path = vim.fn.expand '%:p:h'
  vim.notify('Opening: ' .. path)
  require('common.utils').open_explorer(path)
end, { desc = 'open_current_file_dir' })
