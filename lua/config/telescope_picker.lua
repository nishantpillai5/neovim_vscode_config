_G.loaded_telescope_extension = _G.loaded_telescope_extension or nil

local M = {}

M.keys = {
  { '<leader>Fe', desc = 'extensions' },
}

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>Fe', function()
    if not _G.loaded_telescope_extension then
      local dap_status, _ = pcall(require, 'dap')
      if dap_status then
        require('telescope').load_extension 'dap'
      end

      local project_status, _ = pcall(require, 'telescope.extensions.project')
      if project_status then
        require('telescope').load_extension 'project'
      end

      local worktree_status, _ = pcall(require, 'git-worktree')
      if worktree_status then
        require('telescope').load_extension 'git_worktree'
      end

      local rest_status, _ = pcall(require, 'rest-nvim')
      if rest_status then
        require('telescope').load_extension 'rest'
      end

      -- TODO: check pcalls
      require('telescope').load_extension 'conflicts'
      require('telescope').load_extension 'emoji'
      require('telescope').load_extension 'nerdy'
      require('telescope').load_extension 'diff'
      -- require("telescope").load_extension("yank_history")
      -- require("telescope").load_extension("refactoring")

      local notify_status, _ = pcall(require, 'notify')
      if notify_status then
        require('telescope').load_extension 'notify'
      end

      local noice_status, _ = pcall(require, 'noice')
      if noice_status then
        require('telescope').load_extension 'noice'
      end

      require('telescope').load_extension 'picker_list'
      _G.loaded_telescope_extension = true
    end
    require('telescope').extensions.picker_list.picker_list()
  end)
end

M.config = function()
  M.keymaps()
end

-- M.config()

return M
