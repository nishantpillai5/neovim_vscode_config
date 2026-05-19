local M = {}

M.keys = {
  { '<leader>zOd', desc = 'discord_enable' },
  { '<leader>zOD', desc = 'discord_disable' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>zOd', function()
    vim.notify 'Discord enabled'
  end)
  set_keymap('n', '<leader>zOD', function()
    vim.notify 'Discord disabled'
  end)
end

M.setup = function()
  require('presence').setup {
    auto_update = true,
    neovim_image_text = 'How do I exit it?',
    main_image = 'neovim',
    debounce_timeout = 10,
    enable_line_number = false,
    buttons = false,
    show_time = true,
    -- Rich Presence text options
    editing_text = 'Editing stuff',
    file_explorer_text = 'Looking through files',
    git_commit_text = 'Committing changes',
    plugin_manager_text = 'Managing plugins',
    reading_text = 'Reading files',
    workspace_text = 'Working on %s',
    line_number_text = 'Line %s out of %s',
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
