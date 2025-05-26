local M = {}

M.keys = {
  { '<leader>gg', desc = 'graph' },
  { '<leader>gG', desc = 'graph_all' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>gg', function()
    require('gitgraph').draw({}, { all = false, max_count = 5000 })
  end)
  set_keymap('n', '<leader>gG', function()
    require('gitgraph').draw({}, { all = true, max_count = 5000 })
  end)
end

M.setup = function()
  ---@diagnostic disable-next-line: missing-fields
  require('gitgraph').setup {
    ---@diagnostic disable-next-line: missing-fields
    symbols = {
      merge_commit = 'M',
      commit = '*',
    },
    format = {
      timestamp = '%H:%M:%S %d-%m-%Y',
      fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
    },
    hooks = {
      on_select_commit = function(commit)
        vim.notify('Changes from ' .. commit.msg)
        vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
      end,
      on_select_range_commit = function(from, to)
        vim.notify('Changes from ' .. from.msg .. ' to ' .. to.msg)
        vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
      end,
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
