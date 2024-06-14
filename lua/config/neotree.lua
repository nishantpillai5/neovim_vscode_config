local M = {}

M.keymaps = function()
  local align = require('common.env').ALIGN

  vim.keymap.set('n', '<leader>ee', function()
    vim.cmd('Neotree reveal focus toggle ' .. align)
  end, { desc = 'Explorer.neotree' })

  vim.keymap.set('n', '<leader>eb', function()
    vim.cmd('Neotree reveal focus buffers toggle ' .. align)
  end, { desc = 'Explorer.neotree_buffers' })

  vim.keymap.set('n', '<leader>eg', function()
    vim.cmd('Neotree reveal focus git_status toggle ' .. align)
  end, { desc = 'Explorer.neotree_git' })
end

M.setup = function()
  require('neo-tree').setup {
    window = { mappings = { ['o'] = 'system_open' } },
    filesystem = {
      window = { mappings = { ['o'] = 'system_open' } },
    },
    commands = {
      system_open = function(state)
        local os = require('common.env').OS
        local node = state.tree:get_node()
        local path = node:get_id()

        if os == 'mac' then
          -- macOs: open file in default application in the background.
          vim.fn.jobstart({ 'xdg-open', '-g', path }, { detach = true })
        end
        if os == 'linux' then
          -- Linux: open file in default application
          vim.fn.jobstart({ 'xdg-open', path }, { detach = true })
        end
        if os == 'windows' then
          -- Windows: Without removing the file from the path, it opens in code.exe instead of explorer.exe
          local p
          local lastSlashIndex = path:match '^.+()\\[^\\]*$' -- Match the last slash and everything before it
          if lastSlashIndex then
            p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
          else
            p = path -- If no slash found, return original path
          end
          vim.cmd('silent !start explorer ' .. p)
        end
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
