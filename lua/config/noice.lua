local M = {}

M.lualine = function()
  local lualineY = require('lualine').get_config().tabline.lualine_y or {}
  table.insert(lualineY, {
    require('noice').api.statusline.command.get,
    cond = require('noice').api.statusline.command.has,
  })

  require('lualine').setup { tabline = { lualine_y = lualineY } }
end

M.keys = {
  { '<leader>zn', desc = 'noice_disable' },
  { '<leader>fN', desc = 'notifications' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>zn', function()
    require('noice').cmd 'disable'
  end)

  set_keymap('n', '<leader>fN', function()
    vim.cmd 'Telescope notify'
  end)
end

M.setup = function()
  require('noice').setup {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    presets = {
      bottom_search = false,
      command_palette = false,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
    views = {
      cmdline_popup = {
        border = {
          style = 'single',
          padding = { 0, 1 },
        },
        filter_options = {},
        win_options = {
          winhighlight = 'NormalFloat:NormalFloat',
        },
      },
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'written',
        },
        opts = { skip = true },
      },
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
  M.lualine()
end

-- M.config()

return M
