local M = {}

M.keymaps = function()
  vim.keymap.set('n', '<leader>;f', function()
    vim.cmd [[ Telescope toggleterm_manager ]]
  end, { desc = 'Terminal.find' })

  vim.keymap.set('n', '<leader>f;', function()
    vim.cmd [[ Telescope toggleterm_manager ]]
  end, { desc = 'Find.terminal' })
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
