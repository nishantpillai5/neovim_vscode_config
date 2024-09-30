local M = {}

M.keys = {
  { '<leader>ws', desc = 'save_session' },
  { '<leader>wl', desc = 'load_session' },
  { '<leader>wS', desc = 'save_manual_session' },
  { '<leader>wL', desc = 'load_manual_session' },
  { '<leader>wd', desc = 'delete_session' },
}

-- TODO: integrate with trailblazer
local save_marks = function() end
local load_marks = function() end

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
  local resession = require 'resession'
  vim.keymap.set('n', '<leader>ws', function()
    workspace_session(resession.save)
  end, { desc = 'save_session' })

  vim.keymap.set('n', '<leader>wl', function()
    workspace_session(resession.load)
  end, { desc = 'load_session' })

  vim.keymap.set('n', '<leader>wS', function()
    resession.save()
  end, { desc = 'save_manual_session' })

  vim.keymap.set('n', '<leader>wL', function()
    resession.load()
  end, { desc = 'load_manual_session' })

  vim.keymap.set('n', '<leader>wd', function()
    resession.delete()
  end, { desc = 'delete_session' })
end

M.setup = function()
  require('resession').setup {
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
