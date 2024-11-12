local M = {}

M.keys = {
  { '<leader>gs', desc = 'status' },
  { '<leader>gl', desc = 'log' },
  { '<leader>gza', desc = 'apply' },
  { '<leader>gzs', desc = 'staged' },
  { '<leader>gzp', desc = 'pop' },
  { '<leader>gzz', desc = 'stash' },
  { '<leader>gzZ', desc = 'stash_untracked' },
}

local toggle_fugitive = function()
  local winids = vim.api.nvim_list_wins()
  for _, id in pairs(winids) do
    local status = pcall(vim.api.nvim_win_get_var, id, 'fugitive_status')
    if status then
      vim.api.nvim_win_close(id, false)
      return
    end
  end
  vim.api.nvim_command 'Git'
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>gs', toggle_fugitive)
  set_keymap('n', '<leader>gl', function()
    vim.cmd 'Git log'
  end)
  set_keymap('n', '<leader>gza', function()
    vim.cmd 'Git stash apply'
  end)
  set_keymap('n', '<leader>gzs', function()
    vim.cmd 'Git stash push --staged'
  end)
  set_keymap('n', '<leader>gzp', function()
    vim.cmd 'Git stash pop'
  end)
  set_keymap('n', '<leader>gzz', function()
    vim.cmd 'Git stash'
  end)
  set_keymap('n', '<leader>gzZ', function()
    vim.cmd 'Git stash --include-untracked'
  end)
end

M.setup = function()
  local fugitive_augroup = vim.api.nvim_create_augroup('AUGfugitive', {})
  local autocmd = vim.api.nvim_create_autocmd
  autocmd('BufWinEnter', {
    group = fugitive_augroup,
    pattern = '*',
    callback = function()
      if vim.bo.ft ~= 'fugitive' then
        return
      end

      local bufnr = vim.api.nvim_get_current_buf()
      vim.keymap.set('n', '<leader>P', function()
        vim.cmd [[ Git push ]]
      end, { buffer = bufnr, remap = false, desc = 'push' })

      vim.keymap.set('n', '<leader>p', function()
        vim.cmd [[ Git pull --rebase ]]
      end, { buffer = bufnr, remap = false, desc = 'pull' })
    end,
  })
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
