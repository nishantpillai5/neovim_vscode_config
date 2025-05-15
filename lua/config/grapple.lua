local M = {}

M.cmd = {
  'Grapple',
}

M.keys = {
  { '<leader>a', '<cmd>Grapple tag<cr>', desc = 'grapple_add' },
  { '<leader>h', '<cmd>Grapple toggle_tags<cr>', desc = 'grapple_list' },
  { '<leader>wh', desc = 'grapple_select_scope' },
  { '<C-PageUp>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'grapple_prev' },
  { '<C-PageDown>', '<cmd>Grapple cycle_tags next<cr>', desc = 'grapple_next' },
}

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
      -- TODO: show current scope in prompt
      prompt = 'Select grapple scope:',
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
