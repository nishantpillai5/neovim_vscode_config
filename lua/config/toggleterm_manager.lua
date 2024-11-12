local M = {}

M.keys = {
  { '<leader>f;', desc = 'terminal' },
  { '<leader>fo', desc = 'tasks' },
  { '<leader>;f', desc = 'find' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>;f', function()
    vim.cmd [[ Telescope toggleterm_manager ]]
  end)

  set_keymap('n', '<leader>f;', function()
    vim.cmd [[ Telescope toggleterm_manager ]]
  end)

  -- TODO: filter only overseer
  set_keymap('n', '<leader>fo', function()
    vim.cmd [[ Telescope toggleterm_manager ]]
  end)
end

M.setup = function()
  local toggleterm_manager = require 'toggleterm-manager'
  local actions = toggleterm_manager.actions
  toggleterm_manager.setup {
    mappings = {
      n = {
        ['<CR>'] = { action = actions.toggle_term, exit_on_action = true },
        ['o'] = { action = actions.create_and_name_term, exit_on_action = true },
        ['i'] = { action = actions.create_term, exit_on_action = true },
        ['x'] = { action = actions.delete_term, exit_on_action = false },
      },
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
