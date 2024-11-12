local M = {}

M.keys = {
  { '<leader>fgD', desc = 'changed_files_from_main' },
}

M.cmd = { 'Easypick', 'KeyChangedFilesFromMain' }

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>fgD', ':Easypick changed_files<cr>')
end

M.setup = function()
  local easypick = require 'easypick'
  local base_branch = require('common.utils').get_main_branch()

  local command = ''

  if require('common.env').OS == 'windows' then
    command = 'powershell -command "git diff --name-only $(git merge-base HEAD ' .. base_branch .. ')"'
  else
    command = 'git diff --name-only $(git merge-base HEAD ' .. base_branch .. ' )'
  end

  easypick.setup {
    pickers = {
      {
        name = 'changed_files',
        command = command,
        previewer = easypick.previewers.branch_diff { base_branch = base_branch },
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
