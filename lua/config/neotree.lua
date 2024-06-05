local M = {}

M.keymaps = function()
  local align = require('common.env').ALIGN
  vim.keymap.set('n', '<leader>et', function()
    vim.cmd('Neotree reveal focus toggle ' .. align)
  end, { desc = 'Explorer.neotree' })
end

M.setup = function()
  require('neo-tree').setup {
    window = {
      mappings = {
        ['<leader>E'] = function()
          vim.api.nvim_exec('Neotree focus filesystem left', true)
        end,
        ['<leader>B'] = function()
          vim.api.nvim_exec('Neotree focus buffers left', true)
        end,
        ['<leader>G'] = function()
          vim.api.nvim_exec('Neotree focus git_status left', true)
        end,
        ['o'] = 'system_open',
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['o'] = 'system_open',
        },
      },
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

return M
