_G.terminal_envs = _G.terminal_envs or {}
local M = {}

M.keys = {
  { '<leader>fO', desc = 'terminals' },
  -- { '<leader>fo', desc = 'terminals_all' },
  { '<leader>oF', desc = 'find' },
}

local function pick_terminal()
    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    local function get_terminal_buffers()
      local bufs = vim.api.nvim_list_bufs()
      local results = {}
      for _, bufnr in ipairs(bufs) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
          local name = vim.api.nvim_buf_get_name(bufnr)
          if name:match '^term://' then
            table.insert(results, {
              bufnr = bufnr,
              name = name ~= '' and name or '[No Name]',
            })
          end
        end
      end
      return results
    end

    pickers
      .new({}, {
        prompt_title = 'Terminal Buffers',
        finder = finders.new_table {
          results = get_terminal_buffers(),
          entry_maker = function(entry)
            return {
              value = entry.bufnr,
              display = entry.name,
              ordinal = entry.name,
              bufnr = entry.bufnr,
            }
          end,
        },
        sorter = conf.generic_sorter {},
        previewer = require('telescope.previewers').new_buffer_previewer {
          define_preview = function(self, entry, status)
            local bufnr = entry.bufnr or entry.value
            if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
              return
            end
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
            vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'terminal')
          end,
        },
        attach_mappings = function(prompt_bufnr, map)
          local select_term = function()
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if entry and entry.bufnr then
              vim.api.nvim_set_current_buf(entry.bufnr)
            end
          end
          map('i', '<CR>', select_term)
          map('n', '<CR>', select_term)
          return true
        end,
      })
      :find()
  end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>fO', function()
    vim.cmd [[ Telescope toggleterm_manager ]]
  end)

  set_keymap('n', '<leader>oF', function()
    vim.cmd [[ Telescope toggleterm_manager ]]
  end)

  -- set_keymap('n', '<leader>fo', pick_terminal)
end

M.setup = function()
  local toggleterm_manager = require 'toggleterm-manager'
  local actions = toggleterm_manager.actions
  toggleterm_manager.setup {
    mappings = {
      n = {
        ['<CR>'] = { action = actions.toggle_term, exit_on_action = true },
        ['o'] = { action = actions.create_and_name_term_with_env(_G.terminal_envs), exit_on_action = true },
        ['i'] = { action = actions.create_term_with_env(_G.terminal_envs), exit_on_action = true },
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
