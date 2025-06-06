-- Disable auto-commenting new lines: https://neovim.discourse.group/t/3746
--vim.opt.formatoptions:remove("cro")
vim.cmd [[autocmd BufEnter * set formatoptions-=cro]]

-- All json files are jsonc
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json' },
  callback = function()
    vim.cmd 'set ft=jsonc'
  end,
})

-- Automatically set the cursor to the last known position
local lastplace = vim.api.nvim_create_augroup('LastPlace', {})
vim.api.nvim_clear_autocmds { group = lastplace }
vim.api.nvim_create_autocmd('BufReadPost', {
  group = lastplace,
  pattern = { '*' },
  desc = 'remember last cursor place',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Set comment string for log files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'log',
  command = 'setlocal commentstring=#\\ %s',
})

-- Set comment string for Markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  command = 'setlocal commentstring=<!--\\ %s\\ -->',
})

-- Set conceallevel to 1 for Markdown files in the notes directory
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    local notes_dir = require('common.env').DIR_NOTES
    local current_file = vim.fn.expand('%:p'):gsub('\\', '/'):lower()
    notes_dir = notes_dir:gsub('\\', '/'):lower()
    if current_file:find(notes_dir, 1, true) then
      vim.cmd 'setlocal conceallevel=1'
    end
  end,
})
