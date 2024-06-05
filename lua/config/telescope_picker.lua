local M = {}

M.keymaps = function()
  vim.keymap.set('n', '<leader>Fe', function()
    if not _G.loaded_telescope_extension then
      local dap_status, _ = pcall(require, 'dap')
      if dap_status then
        require('telescope').load_extension 'dap'
      end

      local project_status, _ = pcall(require, 'project_nvim')
      if project_status then
        require('telescope').load_extension 'projects'
      end

      local worktree_status, _ = pcall(require, 'git-worktree')
      if worktree_status then
        require('telescope').load_extension 'git_worktree'
      end

      local rest_status, _ = pcall(require, 'rest-nvim')
      if rest_status then
        require("telescope").load_extension("rest")
      end

      require('telescope').load_extension 'conflicts'
      require('telescope').load_extension 'emoji'
      require('telescope').load_extension 'nerdy'
      -- require("telescope").load_extension("yank_history")
      -- require("telescope").load_extension("refactoring")
      require('telescope').load_extension 'notify'
      require('telescope').load_extension 'picker_list'
      _G.loaded_telescope_extension = true
    end
    require('telescope').extensions.picker_list.picker_list()
  end, { desc = 'Find.telescope_extensions' })
end

return M
