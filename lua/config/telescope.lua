local M = {}

local default_opts = {
  follow = true,
  path_display = { filename_first = { reverse_directories = true } },
}

local is_inside_work_tree = {}
-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
M.project_files = function()
  local builtin = require 'telescope.builtin'

  local cwd = vim.fn.getcwd()
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system 'git rev-parse --is-inside-work-tree'
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  if is_inside_work_tree[cwd] then
    builtin.git_files(default_opts)
  else
    builtin.find_files(default_opts)
  end
end

M.keymaps = function()
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>:', builtin.commands, { desc = 'find_commands' })
  vim.keymap.set('n', '<leader>ff', M.project_files, { desc = 'Find.git_files' })

  vim.keymap.set('n', '<leader>fa', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local basename = vim.fn.fnamemodify(bufname, ':t:r'):lower()
    builtin.git_files { default_text = basename }
  end, { desc = 'Find.alternate' })

  vim.keymap.set('n', '<leader>fA', builtin.find_files, { desc = 'Find.all' })

  vim.keymap.set('n', '<leader>fgs', builtin.git_status, { desc = 'Find.Git.status' })
  vim.keymap.set('n', '<leader>fgb', builtin.git_branches, { desc = 'Find.Git.branches' })
  vim.keymap.set('n', '<leader>fgc', builtin.git_bcommits, { desc = 'Find.Git.commits' })
  vim.keymap.set('n', '<leader>fgz', builtin.git_stash, { desc = 'Find.Git.stash' })

  vim.keymap.set('n', '<leader>fl', builtin.live_grep, { desc = 'Find.Live_grep.global' })
  vim.keymap.set(
    'n',
    '<leader>fL',
    "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
    { desc = 'Find.Live_grep.global_with_args' }
  )

  vim.keymap.set('n', '<leader>f/', function()
    builtin.live_grep {
      grep_open_files = true,
    }
  end, { desc = 'Find.Search.in_buffers' })

  vim.keymap.set('n', '<leader>f?', function()
    builtin.grep_string { search = vim.fn.input 'Search > ' }
  end, { desc = 'Find.Search.global' })

  vim.keymap.set('n', '<leader>fw', function()
    local word = vim.fn.expand '<cword>'
    builtin.grep_string { search = word }
  end, { desc = 'Find.word' })

  vim.keymap.set('n', '<leader>fW', function()
    local word = vim.fn.expand '<cWORD>'
    builtin.grep_string { search = word }
  end, { desc = 'Find.whole_word' })

  vim.keymap.set('n', '<leader>F', '<cmd>Telescope<cr>', { desc = 'Find.telescope' })

  vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Find.symbols' })
  vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Find.marks' })
  vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = 'Find.registers' })
  vim.keymap.set('n', '<leader>fh', builtin.buffers, { desc = 'Find.buffers' })
  -- vim.keymap.set("n", "<leader>fp", "<cmd>Telescope yank_history<cr>")
  -- TODO: use string instead to prevent loading extensions?
  -- vim.keymap.set({ "n", "x" }, "<leader>rr", function()
  --   require("telescope").extensions.refactoring.refactors()
  -- end)

  vim.keymap.set('n', '<leader>fn', function()
    builtin.find_files { cwd = require('common.env').DIR_NOTES }
  end, { desc = 'Find.notes' })
end

M.setup = function()
  local action_layout = require 'telescope.actions.layout'
  default_opts = {
    follow = true,
    path_display = { filename_first = { reverse_directories = true } },
    preview = {
      filesize_limit = 0.5, -- MB
    },
    mappings = {
      n = {
        ['<M-p>'] = action_layout.toggle_preview,
      },
      i = {
        ['<M-p>'] = action_layout.toggle_preview,
      },
    },
  }

  local lga_actions = require 'telescope-live-grep-args.actions'
  require('telescope').setup {
    defaults = default_opts,
    pickers = {
      find_files = default_opts,
      live_grep = default_opts,
      grep_string = default_opts,
      git_files = default_opts,
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
      live_grep_args = {
        auto_quoting = true,
        mappings = {
          i = {
            ['<C-k>'] = lga_actions.quote_prompt(),
            ['<C-i>'] = lga_actions.quote_prompt { postfix = ' --iglob ' },
          },
        },
      },
    },
  }

  _G.loaded_telescope_extension = false
  require('telescope').load_extension 'fzf'
end

return M
