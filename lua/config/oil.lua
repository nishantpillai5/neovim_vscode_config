local M = {}

M.keys = {
  { '<leader>ef', '<cmd>Oil<cr>', desc = 'oil' },
}

function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require('oil').get_current_dir(bufnr)
  if dir then
    local rel = vim.fn.fnamemodify(dir, ':~:.')
    if rel == '.' then
      return vim.fn.fnamemodify(dir, ':~')
    else
      return rel
    end
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

M.setup = function()
  local detail = false
  require('oil').setup {
    -- Keep netrw enabled
    default_file_explorer = false,
    columns = {
      'icon',
    },
    delete_to_trash = true,
    use_default_keymaps = false,
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n', desc = 'oil_help' },
      ['<CR>'] = 'actions.select',
      ['zp'] = { 'actions.preview', desc = 'oil_preview' },
      -- only autocomplete one line at a time
      ['zv'] = { 'actions.select', opts = { vertical = true }, desc = 'oil_select_vertical' },
      ['zs'] = { 'actions.select', opts = { horizontal = true }, desc = 'oil_select_horizontal' },
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['<C-r>'] = 'actions.refresh',
      ['zr'] = { 'actions.refresh', desc = 'oil_refresh' },
      ['-'] = { 'actions.parent', mode = 'n', desc = 'oil_parent' },
      ['_'] = { 'actions.open_cwd', mode = 'n', desc = 'oil_open_cwd' },
      ['~'] = { 'actions.cd', mode = 'n', desc = 'oil_cwd' },
      ['zo'] = { 'actions.change_sort', mode = 'n', desc = 'oil_order_by' },
      ['gx'] = 'actions.open_external',
      ['zh'] = { 'actions.toggle_hidden', mode = 'n', desc = 'oil_toggle_hidden' },
      ['zt'] = { 'actions.toggle_trash', mode = 'n', desc = 'oil_toggle_trash' },
      ['zd'] = {
        desc = 'oil_toggle_detail',
        callback = function()
          detail = not detail
          if detail then
            require('oil').set_columns { 'permissions', 'size', 'mtime', 'icon' }
          else
            require('oil').set_columns { 'icon' }
          end
        end,
      },
    },
    win_options = {
      winbar = '%!v:lua.get_oil_winbar()',
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
