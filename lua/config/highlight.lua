local M = {}

M.keys = {
  { '<leader>zh', ':<c-u>HSHighlight 3<CR>', mode = { 'n', 'v' }, desc = 'highlight' },
  { '<leader>zx', ':<c-u>HSRmHighlight<CR>', mode = { 'n', 'v' }, desc = 'highlight_delete' },
  { '<leader>zX', ':<c-u>HSRmHighlight rm_all<CR>', mode = { 'n', 'v' }, desc = 'highlight_delete_all' },
}

M.keymaps = function()
  -- TODO: mark_at_pos on highlight
  -- TODO: export doesn't work

  -- vim.keymap.set({ 'n', 'v' }, '<leader>zh', function()
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
      color_0 = { '#0c0d0e', 'smart' }, -- Cosmic charcoal
      color_1 = { '#e5c07b', 'smart' }, -- Pastel yellow
      color_2 = { '#7FFFD4', 'smart' }, -- Aqua menthe
      color_3 = { '#8A2BE2', 'smart' }, -- Proton purple
      color_4 = { '#FF4500', 'smart' }, -- Orange red
      color_5 = { '#008000', 'smart' }, -- Office green
      color_6 = { '#0000FF', 'smart' }, -- Just blue
      color_7 = { '#FFC0CB', 'smart' }, -- Blush pink
      color_8 = { '#FFF9E3', 'smart' }, -- Cosmic latte
      color_9 = { '#7d5c34', 'smart' }, -- Fallow brown
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
