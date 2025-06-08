local M = {}

M.cmd = {
  'Grapple',
}

M.keys_all = {
  { '<leader>a', '<cmd>Grapple tag<cr>', desc = 'grapple_add' },
  { '<leader>h', '<cmd>Grapple toggle_tags<cr>', desc = 'grapple_list', vsc_cmd = 'workbench.action.quickOpenPreviousRecentlyUsedEditor' },
  { '<leader>wh', desc = 'grapple_select_scope' },
  { '<A-PageUp>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'grapple_prev' },
  { '<A-PageDown>', '<cmd>Grapple cycle_tags next<cr>', desc = 'grapple_next' },
}
M.keys = require('common.utils').filter_keymap(M.keys_all)

M.lualine = function()
  local lualineA = require('lualine').get_config().tabline.lualine_a or {}
  table.insert(lualineA, { 'grapple' })

  require('lualine').setup { tabline = { lualine_a = lualineA } }
end

M.keymaps = function()
  local scopes_options = {
    { key = 'git_branch', desc = 'Git root directory and branch' },
    { key = 'git', desc = 'Git root directory' },
    { key = 'cwd', desc = 'Current working directory' },
    { key = 'global', desc = 'Global scope' },
    { key = 'lsp', desc = 'LSP root directory' },
    { key = 'static', desc = 'Initial working directory' },
  }

  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>wh', function()
    vim.ui.select(scopes_options, {
      prompt = 'Current scope: ' .. require('grapple').app().settings.scope .. ' | Change scope to :',
      format_item = function(item)
        return string.format('%s: %s', item.key, item.desc)
      end,
    }, function(selected)
      if selected then
        require('grapple').use_scope(selected.key)
      end
    end)
  end)
end

M.setup = function()
  require('grapple').setup {
    scope = 'git_branch',
    win_opts = {
      width = 0.8,
    },
    integrations = {
      resession = true,
    },
  }
end

M.config = function()
  M.setup()
  M.lualine()
  M.keymaps()
end

-- M.config()

return M
