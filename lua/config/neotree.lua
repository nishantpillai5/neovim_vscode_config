_G.fav_dirs = _G.fav_dirs or nil

local M = {}

local utils = require 'common.utils'
local EXCLUDED_FTS = { 'terminal', 'Trouble', 'qf', 'edgy' }

M.cmd = { 'Neotree' }

M.keys = {
  { '<leader>ee', desc = 'explorer' },
  { '<leader>eE', desc = 'explorer_cwd' },
  { '<leader>eb', desc = 'buffers' },
  { '<leader>eg', desc = 'git' },
  { '<leader>fe', desc = 'explorer' },
  { '<leader>fE', desc = 'explorer_open' },
}

local select_dir = function(prompt, callback)
  local local_favs = _G.fav_dirs or {}
  local global_favs = {
    notes = require('common.env').DIR_NOTES,
    nvim_config = require('common.env').DIR_NVIM,
    vsc_config = require('common.env').VSC_CONFIG:gsub('settings.json', ''),
  }
  local fav_dirs = vim.tbl_deep_extend('force', global_favs, local_favs)

  vim.ui.select(utils.get_keys(fav_dirs), {
    prompt = prompt,
    telescope = require('telescope.themes').get_cursor(),
  }, function(selected)
    if selected == nil then
      return
    end
    callback(fav_dirs[selected])
  end)
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>ee', function()
    vim.cmd 'Neotree reveal focus'
  end)

  set_keymap('n', '<leader>eE', function()
    vim.cmd('Neotree reveal focus dir=' .. vim.fn.getcwd())
  end)

  set_keymap('n', '<leader>eb', function()
    vim.cmd 'Neotree reveal focus buffers'
  end)

  set_keymap('n', '<leader>eg', function()
    vim.cmd 'Neotree reveal focus git_status'
  end)

  set_keymap('n', '<leader>fe', function()
    select_dir('Favorite directories', function(selected)
      vim.cmd('Neotree reveal focus' .. ' dir=' .. selected)
    end)
  end)

  set_keymap('n', '<leader>fE', function()
    select_dir('Favorite directories', function(selected)
      require('common.utils').open_explorer(selected)
    end)
  end)
end

M.setup = function()
  require('neo-tree').setup {
    open_files_do_not_replace_types = EXCLUDED_FTS,
    bind_to_cwd = false,
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
        local stat = vim.loop.fs_stat(path)
        -- If the node is a file, open its parent directory
        if stat and stat.type == 'file' then
          path = vim.fn.fnamemodify(path, ':h')
        end
        require('common.utils').open_explorer(path)
      end,
    },
  }

  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = 'neo-tree',
    callback = function()
      vim.cmd 'normal! zz'
    end,
  })
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
