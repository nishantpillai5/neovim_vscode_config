local keys = {
  { '<leader>s', desc = 'save' },
  { '<leader>S', desc = 'save_force' },
  { '<leader>x', desc = 'quit' },
  { '<leader>X', desc = 'buffer_delete' },
  { '<leader>zv', desc = 'vertical_split' },
  { '<leader>zs', desc = 'horizontal_split' },
  { '<C-Right>', desc = 'vertical_resize_right' },
  { '<C-Left>', desc = 'vertical_resize_left' },
  { '<C-Up>', desc = 'vertical_resize_up' },
  { '<C-Down>', desc = 'horizontal_resize_down' },
  { '<Esc>', desc = 'exit_terminal' },

  { '<leader>eO', desc = 'open_explorer' },
  { '<leader>eyy', desc = 'yank_absolute_path' },
  { '<leader>eyY', desc = 'yank_relative_path' },
  { '<leader>eyf', desc = 'yank_filename' },
  { '<leader>eyF', desc = 'yank_folder' },
  { '<leader>oO', desc = 'generate_output' },
}

local set_keymap = require('common.utils').get_keymap_setter(keys)

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

set_keymap('n', '<leader>oO', function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].buftype ~= 'terminal' then
    vim.notify('Not a terminal buffer', vim.log.levels.WARN)
    return
  end
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  while #lines > 0 and lines[#lines]:match('^%s*$') do
    table.remove(lines, #lines)
  end
  local term_name = vim.api.nvim_buf_get_name(bufnr)
  local output_name = term_name .. '.output'

  -- Check if a buffer with the same name exists
  local existing_buf = nil
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(b) == output_name then
      existing_buf = b
      break
    end
  end

  local new_buf = existing_buf or vim.api.nvim_create_buf(true, false) -- listed, not scratch

  -- Set buffer options to avoid save prompts
  vim.bo[new_buf].buftype = 'nofile'
  vim.bo[new_buf].bufhidden = 'hide'
  vim.bo[new_buf].swapfile = false
  vim.bo[new_buf].modifiable = true

  vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_name(new_buf, output_name)
  vim.api.nvim_set_current_buf(new_buf)
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(new_buf), 0 })

  vim.bo[new_buf].filetype = 'log'
end)
