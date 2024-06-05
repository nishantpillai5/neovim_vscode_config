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
