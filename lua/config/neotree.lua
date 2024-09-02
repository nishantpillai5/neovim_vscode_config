local M = {}

local utils = require 'common.utils'

M.keys = {
  { '<leader>ee', desc = 'explorer' },
  { '<leader>eb', desc = 'buffers' },
  { '<leader>eg', desc = 'git' },
  { '<leader>eE', desc = 'toggle' },
  { '<leader>fe', desc = 'explorer' },
}

local sidebar_align = function()
  return require('common.env').SIDEBAR_POSITION
end

local find_dir = function()
  local local_favs = _G.fav_dirs or {}
  local global_favs = {
    notes = require('common.env').DIR_NOTES,
    nvim_config = require('common.env').DIR_NVIM,
  }
  local fav_dirs = utils.merge_table(global_favs, local_favs)

  vim.ui.select(utils.get_keys(fav_dirs), {
    prompt = 'Favorite directories',
    telescope = require('telescope.themes').get_cursor(),
  }, function(selected)
    if selected == nil then
      return
    end
    vim.cmd('Neotree reveal focus ' .. sidebar_align() .. ' dir=' .. fav_dirs[selected])
  end)
end

M.keymaps = function()
  vim.keymap.set('n', '<leader>ee', function()
    vim.cmd('Neotree reveal focus ' .. sidebar_align())
  end, { desc = 'explorer' })

  vim.keymap.set('n', '<leader>eb', function()
    vim.cmd('Neotree reveal focus buffers ' .. sidebar_align())
  end, { desc = 'buffers' })

  vim.keymap.set('n', '<leader>eg', function()
    vim.cmd('Neotree reveal focus git_status ' .. sidebar_align())
  end, { desc = 'git' })

  vim.keymap.set('n', '<leader>eE', function()
    vim.cmd 'Neotree toggle last'
  end, { desc = 'toggle' })

  vim.keymap.set('n', '<leader>fe', find_dir, { desc = 'explorer' })
end

M.setup = function()
  require('neo-tree').setup {
    close_if_last_window = true,
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
    },
    git_status = {
      window = {
        mappings = {
          ['s'] = 'git_add_file',
          ['u'] = 'git_unstage_file',
          ['c'] = 'git_commit',
        },
      },
    },
    window = {
      mappings = {
        ['o'] = 'system_open',
        ['e'] = 'close_window',
        ['s'] = 'open_split',
        ['v'] = 'open_vsplit',
        ['O'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
        ['Oc'] = { 'order_by_created', nowait = false },
        ['Od'] = { 'order_by_diagnostics', nowait = false },
        ['Og'] = { 'order_by_git_status', nowait = false },
        ['Om'] = { 'order_by_modified', nowait = false },
        ['On'] = { 'order_by_name', nowait = false },
        ['Os'] = { 'order_by_size', nowait = false },
        ['Ot'] = { 'order_by_type', nowait = false },
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

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
