_G.fav_dirs = _G.fav_dirs or nil

local M = {}

local utils = require 'common.utils'
local EXCLUDED_FTS = { 'terminal', 'Trouble', 'qf', 'edgy' }

M.keys = {
  { '<leader>ee', desc = 'explorer' },
  { '<leader>eb', desc = 'buffers' },
  { '<leader>eg', desc = 'git' },
  { '<leader>fe', desc = 'explorer' },
}

local find_dir = function()
  local local_favs = _G.fav_dirs or {}
  local global_favs = {
    notes = require('common.env').DIR_NOTES,
    nvim_config = require('common.env').DIR_NVIM,
    vsc_config = require('common.env').VSC_CONFIG:gsub('settings.json', ''),
  }
  local fav_dirs = utils.merge_table(global_favs, local_favs)

  vim.ui.select(utils.get_keys(fav_dirs), {
    prompt = 'Favorite directories',
    telescope = require('telescope.themes').get_cursor(),
  }, function(selected)
    if selected == nil then
      return
    end
    vim.cmd('Neotree reveal focus' .. ' dir=' .. fav_dirs[selected])
  end)
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>ee', function()
    vim.cmd 'Neotree reveal focus'
  end)

  set_keymap('n', '<leader>eb', function()
    vim.cmd 'Neotree reveal focus buffers'
  end)

  set_keymap('n', '<leader>eg', function()
    vim.cmd 'Neotree reveal focus git_status'
  end)

  set_keymap('n', '<leader>fe', find_dir)
end

M.setup = function()
  require('neo-tree').setup {
    open_files_do_not_replace_types = EXCLUDED_FTS,
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
        local node = state.tree:get_node()
        local path = node:get_id()
        require('common.utils').open_explorer(path)
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
