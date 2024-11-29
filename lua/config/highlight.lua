local M = {}

M.keys = {
  -- { '<leader>zhh', mode = { 'n', 'v' }, desc = 'highlight' },
  { '<leader>zhh', ':<c-u>HSHighlight 1<CR>', mode = { 'n', 'v' }, desc = 'highlight' },

  { '<leader>zhx', ':<c-u>HSRmHighlight<CR>', mode = { 'n', 'v' }, desc = 'remove' },
  { '<leader>zhX', ':<c-u>HSRmHighlight rm_all<CR>', mode = { 'n', 'v' }, desc = 'remove_all' },
  { '<leader>zhs', ':HSExport<CR>', desc = 'save' },
  { '<leader>zhl', ':HSImport<CR>', desc = 'load' },
}

local colors = {
  cosmic_charcoal = '#0c0d0e',
  pastel_yellow = '#e5c07b',
  aqua_menthe = '#7FFFD4',
  proton_purple = '#8A2BE2',
  orange_red = '#FF4500',
  office_green = '#008000',
  just_blue = '#0000FF',
  blush_pink = '#FFC0CB',
  cosmic_latte = '#FFF9E3',
  fallow_brown = '#7d5c34',
}

local color_names = require('common.utils').get_keys(colors)

for i = 0, 9 do
  table.insert(
    M.keys,
    { '<leader>zh' .. i, ':<c-u>HSHighlight ' .. i .. '<CR>', mode = { 'n', 'v' }, desc = color_names[i + 1] }
  )
end

M.keymaps = function()
  -- TODO: mark_at_pos on highlight only on zhh

  -- normal mode zhh, hightlight line

  -- FIXME: save doesn't remove previous highlights

  -- FIXME: zhX removed lsp hints

  -- set_keymap({ 'n', 'v' }, '<leader>zh', function()
  --   vim.cmd [[ HSHighlight 1 ]]
  --   require('config.trailblazer').mark_at_pos()
  -- end, { desc = 'highlight' })
end

M.setup = function()
  require('high-str').setup {
    verbosity = 0,
    saving_path = vim.fn.stdpath 'data' .. '/highstr/',
    highlight_colors = {
      -- color_id = {"bg_hex_code",<"fg_hex_code"/"smart">}
      color_0 = { colors.cosmic_charcoal, 'smart' },
      color_1 = { colors.pastel_yellow, 'smart' },
      color_2 = { colors.aqua_menthe, 'smart' },
      color_3 = { colors.proton_purple, 'smart' },
      color_4 = { colors.orange_red, 'smart' },
      color_5 = { colors.office_green, 'smart' },
      color_6 = { colors.just_blue, 'smart' },
      color_7 = { colors.blush_pink, 'smart' },
      color_8 = { colors.cosmic_latte, 'smart' },
      color_9 = { colors.fallow_brown, 'smart' },
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
