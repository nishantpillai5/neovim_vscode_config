local M = {}

local workspace_session = function(action)
  local status, neoscopes = pcall(require, 'neoscopes')
  if status then
    local current_scope = neoscopes.get_current_scope()
    if current_scope ~= nil then
      action(current_scope.name)
    else
      action 'workspace'
    end
  else
    action 'workspace'
  end
end

M.keymaps = function()
  local recession = require 'resession'
  vim.keymap.set('n', '<leader>ws', function()
    workspace_session(recession.save)
  end, { desc = 'save_session' })

  vim.keymap.set('n', '<leader>wl', function()
    workspace_session(recession.load)
  end, { desc = 'load_session' })

  vim.keymap.set('n', '<leader>wS', function()
    recession.save()
  end, { desc = 'save_manual_session' })

  vim.keymap.set('n', '<leader>wL', function()
    recession.load()
  end, { desc = 'load_manual_session' })

  vim.keymap.set('n', '<leader>wd', function()
    recession.delete()
  end, { desc = 'delete_session' })
end

M.setup = function()
  local recession = require 'resession'
  recession.setup {
    extensions = {
      overseer = { recent_first = true },
      grapple = {},
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
