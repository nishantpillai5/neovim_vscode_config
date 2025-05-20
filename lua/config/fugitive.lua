local M = {}

M.keys = {
  { '<leader>gs', desc = 'status' },
  { '<leader>gb', desc = 'branch' },
  { '<leader>g;', desc = 'log' },
  { '<leader>gza', desc = 'apply' },
  { '<leader>gzs', desc = 'staged' },
  { '<leader>gzp', desc = 'pop' },
  { '<leader>gzz', desc = 'stash' },
  { '<leader>gzZ', desc = 'stash_untracked' },
  { '<leader>gr', desc = 'reload' },
}

M.buffer_keys = {
  { '<leader>p', desc = 'pull' },
  { '<leader>P', desc = 'push' },
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

local stash_with_message = function()
  vim.ui.input({ prompt = 'Stash message: ' }, function(input)
    if input then
      vim.cmd('Git stash push -m "' .. input .. '"')
    end
  end)
end

local stash_untracked_with_message = function()
  vim.ui.input({ prompt = 'Stash message: ' }, function(input)
    if input then
      vim.cmd('Git stash push --include-untracked -m "' .. input .. '"')
    end
  end)
end

local reload_fugitive_buffer = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == 'fugitive' then
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.cmd 'Git'
      vim.cmd 'wincmd p'
    end
  end
end

_G.fugitive_create_branch = function()
  vim.ui.input({ prompt = 'Branch name: ' }, function(input)
    if input then
      vim.cmd('Git branch ' .. input)
    end
  end)
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>gs', toggle_fugitive)

  set_keymap('n', '<leader>gb', _G.fugitive_create_branch)

  set_keymap('n', '<leader>g;', function()
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
  set_keymap('n', '<leader>gzz', stash_with_message)
  set_keymap('n', '<leader>gzZ', stash_untracked_with_message)
  set_keymap('n', '<leader>gr', reload_fugitive_buffer)
end

M.setup = function()
  local fugitive_augroup = vim.api.nvim_create_augroup('AUGfugitive', {})
  local set_buf_keymap = require('common.utils').get_keymap_setter(M.buffer_keys)
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = fugitive_augroup,
    pattern = '*',
    callback = function()
      if vim.bo.ft ~= 'fugitive' then
        return
      end

      local bufnr = vim.api.nvim_get_current_buf()
      set_buf_keymap('n', '<leader>P', function()
        vim.cmd [[ Git push ]]
      end, { buffer = bufnr })

      set_buf_keymap('n', '<leader>p', function()
        vim.cmd [[ Git pull --rebase ]]
      end, { buffer = bufnr })
    end,
  })
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
