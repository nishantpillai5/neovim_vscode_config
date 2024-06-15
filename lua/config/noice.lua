local M = {}

M.lualine = function()
  local lualineY = require('lualine').get_config().tabline.lualine_y or {}
  table.insert(lualineY, {
     require("noice").api.statusline.command.get,
     cond = require("noice").api.statusline.command.has,
   })

  require('lualine').setup { tabline = { lualine_y = lualineY } }
end

M.keymaps = function()
  vim.keymap.set('n', '<leader>zn', function()
    require('noice').cmd 'disable'
  end, { desc = 'Visual.noice_disable' })
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
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
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
