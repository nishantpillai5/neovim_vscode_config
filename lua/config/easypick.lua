local M = {}

local get_main_branch = function()
  if _G.main_branch then
    return _G.main_branch
  end

  local get_default_branch = "git rev-parse --symbolic-full-name refs/remotes/origin/HEAD | sed 's!.*/!!'"
  return vim.fn.system(get_default_branch) or 'main'
end

M.keymaps = function()
  vim.api.nvim_set_keymap('n', '<leader>fgD', ':Easypick changed_files<cr>', { desc = 'diff_files_from_main' })
end

M.setup = function()
  local easypick = require 'easypick'
  local base_branch = get_main_branch()

  local command = ''

  if require('common.env').OS == 'windows' then
    command = 'FOR /F "tokens=*" %i IN (\'git merge-base HEAD ' .. base_branch .. "') DO git diff --name-only %i"
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
