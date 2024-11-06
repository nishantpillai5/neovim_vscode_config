_G.loaded_telescope_extension = _G.loaded_telescope_extension or false

local utils = require 'common.utils'
local builtin = require 'telescope.builtin'

local plenary_ok, PlenaryJob = pcall(require, 'plenary.job')
if not plenary_ok then
  vim.notify 'plenary not found'
  return
end

local default_opts = {
  follow = true,
  path_display = { filename_first = { reverse_directories = true } },
}

local ripgrep_base_cmd = {
  'rg',
  '--color=never',
  '--no-heading',
}

local content_ripgrep_base_cmd = utils.merge_list(ripgrep_base_cmd, {
  '--with-filename',
  '--line-number',
  '--column',
  '--smart-case',
})

local function trimGitModificationIndicator(cmd_output)
  return cmd_output:match '[^%s]+$'
end

local function constrain_to_scope()
  local neoscopes = require 'neoscopes'
  local success, scope = pcall(neoscopes.get_current_scope)
  if not success or not scope then
    -- utils.print('no current scope')
    return {}, {}
  end
  local find_command_opts = {}
  local search_dir_opts = {}
  local pattern = '^file:///'
  for _, dir_name in ipairs(scope.dirs) do
    if dir_name then
      if dir_name:find(pattern) ~= nil then
        table.insert(find_command_opts, '--glob')
        local file_name = dir_name:gsub(pattern, '')
        -- require('user.utils').print(file_name)
        -- table.insert(find_command_opts, string.gsub(dir_name, pattern, ""))
        table.insert(find_command_opts, file_name)
      else
        table.insert(search_dir_opts, dir_name)
      end
    end
  end
  for _, file_name in ipairs(scope.files) do
    if file_name then
      table.insert(find_command_opts, '--glob')
      -- require('user.utils').print('included' .. file_name)
      -- table.insert(find_command_opts, string.gsub(dir_name, pattern, ""))
      table.insert(find_command_opts, file_name)
    end
  end
  return find_command_opts, search_dir_opts
end

local function live_grep_static_file_list(opts, file_list)
  opts = opts or {}
  opts.cwd = utils.get_root_dir()
  local cmd_opts, dir_opts = constrain_to_scope()

  local vimgrep_arguments = utils.merge_list(content_ripgrep_base_cmd, {
    -- "--no-ignore", -- **This is the added flag**
    '--hidden', -- **Also this flag. The combination of the two is the same as `-uu`**
  })
  vimgrep_arguments = utils.merge_list(vimgrep_arguments, file_list)
  vimgrep_arguments = utils.merge_list(vimgrep_arguments, cmd_opts)
  opts.vimgrep_arguments = vimgrep_arguments

  opts.search_dirs = opts.search_dirs or {}
  opts.search_dirs = utils.merge_list(opts.search_dirs, dir_opts)
  builtin.live_grep(opts)
end

local live_grep_git_changed_files = function(opts)
  local file_list = {}
  PlenaryJob:new({
    command = 'git',
    args = { 'status', '--porcelain', '-u' },
    cwd = utils.get_root_dir(),
    on_exit = function(job)
      for _, cmd_output in ipairs(job:result()) do
        table.insert(file_list, '--glob')
        table.insert(file_list, trimGitModificationIndicator(cmd_output))
      end
    end,
  }):sync()

  live_grep_static_file_list(opts, file_list)
end

local live_grep_git_changed_cmp_base_branch = function(opts)
  local base_branch = utils.get_main_branch()
  local file_list = {}
  PlenaryJob:new({
    command = 'git',
    args = { 'diff', '--name-only', base_branch .. '..HEAD' },
    cwd = utils.get_root_dir(),
    on_exit = function(job)
      for _, cmd_output in ipairs(job:result()) do
        table.insert(file_list, '--glob')
        table.insert(file_list, cmd_output)
      end
    end,
  }):sync()
  live_grep_static_file_list(opts, file_list)
end

local is_inside_work_tree = {}
-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local project_files = function()
  local cwd = vim.fn.getcwd()
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system 'git rev-parse --is-inside-work-tree'
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  if is_inside_work_tree[cwd] then
    local git_opts = default_opts
    git_opts['show_untracked'] = true
    builtin.git_files(git_opts)
  else
    builtin.find_files(default_opts)
  end
end

------------------------------------------------ Public ------------------------------------------------

local M = {}

M.keys = {
  { '<leader>:', desc = 'find_commands' },
  { '<leader>ff', desc = 'git_files' },
  { '<leader>fF', desc = 'ignored_files' },
  { '<leader>fa', desc = 'all' },
  { '<leader>fA', desc = 'alternate' },
  { '<leader>fgd', desc = 'changed_files' },
  { '<leader>fgb', desc = 'branch_checkout' },
  -- { '<leader>fgB', desc = 'branch_diff' },
  { '<leader>fgc', desc = 'commits_checkout' },
  { '<leader>fgC', desc = 'commits_diff' },
  { '<leader>fgz', desc = 'stash' },
  { '<leader>fgx', desc = 'conflicts' },
  { '<leader>fgl', desc = 'live_grep_changed_files' },
  { '<leader>fgL', desc = 'live_grep_changed_files_from_main' },
  { '<leader>ft', desc = 'todos' },
  { '<leader>fl', desc = 'live_grep_global' },
  { '<leader>fL', desc = 'live_grep_global_with_args' },
  { '<leader>/', desc = 'find_local' },
  { '<leader>?', desc = 'find_global' },
  { '<leader>fw', desc = 'word' },
  { '<leader>fW', desc = 'whole_word' },
  { '<leader>Ff', desc = 'builtin' },
  { '<leader>fs', desc = 'symbols' },
  { '<leader>wf', desc = 'find_session' },
  { '<leader>fm', desc = 'marks' },
  { '<leader>fr', desc = 'recents' },
  { '<leader>f"', desc = 'registers' },
  { '<leader>fh', desc = 'buffers' },
  -- { "<leader>fp", desc = "yank" },
  { '<leader>wc', desc = 'configurations' },
}

M.keymaps = function()
  vim.keymap.set('n', '<leader>:', builtin.commands, { desc = 'find_commands' })
  vim.keymap.set('n', '<leader>ff', project_files, { desc = 'git_files' })

  vim.keymap.set('n', '<leader>fF', function()
    local prefix = require('common.env').GITIGNORE_PREFIX
    builtin.find_files { default_text = prefix, no_ignore = true }
  end, { desc = 'ignored_files' })

  vim.keymap.set('n', '<leader>fa', builtin.find_files, { desc = 'all' })

  vim.keymap.set('n', '<leader>fA', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local basename = vim.fn.fnamemodify(bufname, ':t:r'):lower()
    builtin.git_files { default_text = basename }
  end, { desc = 'alternate' })

  vim.keymap.set('n', '<leader>fgd', builtin.git_status, { desc = 'changed_files' })
  vim.keymap.set('n', '<leader>fgb', builtin.git_branches, { desc = 'branches_checkout' })
  -- vim.keymap.set('n', '<leader>fgB', builtin.git_branches, { desc = 'branches_diff' })
  vim.keymap.set('n', '<leader>fgc', builtin.git_bcommits, { desc = 'commits_checkout' })
  vim.keymap.set('n', '<leader>fgC', require('telescope').extensions.git_diffs.diff_commits, { desc = 'commits_diff' })
  vim.keymap.set('n', '<leader>fgz', builtin.git_stash, { desc = 'stash' })
  vim.keymap.set('n', '<leader>fgx', '<cmd>Telescope conflicts<cr>', { desc = 'conflicts' })

  vim.keymap.set('n', '<leader>fgl', live_grep_git_changed_files, { desc = 'live_grep_changed_files' })
  vim.keymap.set(
    'n',
    '<leader>fgL',
    live_grep_git_changed_cmp_base_branch,
    { desc = 'live_grep_changed_files_from_main' }
  )

  vim.keymap.set('n', '<leader>ft', function()
    live_grep_git_changed_cmp_base_branch { default_text = require('common.env').TODO_CUSTOM .. ':' }
  end, { desc = 'todos_in_branch(' .. require('common.env').TODO_CUSTOM .. ')' })

  vim.keymap.set('n', '<leader>fl', builtin.live_grep, { desc = 'live_grep_global' })

  vim.keymap.set('n', '<leader>fL', function()
    require('telescope').extensions.live_grep_args.live_grep_args()
  end, { desc = 'live_grep_global_with_args' })

  vim.keymap.set('n', '<leader>/', function()
    vim.cmd 'Telescope current_buffer_fuzzy_find'
  end, { desc = 'find_local' })

  vim.keymap.set('n', '<leader>?', function()
    builtin.grep_string { search = vim.fn.input 'Search > ' }
  end, { desc = 'find_global' })

  vim.keymap.set('n', '<leader>fw', function()
    local word = vim.fn.expand '<cword>'
    builtin.grep_string { search = word }
  end, { desc = 'word' })

  vim.keymap.set('n', '<leader>fW', function()
    local word = vim.fn.expand '<cWORD>'
    builtin.grep_string { search = word }
  end, { desc = 'whole_word' })

  vim.keymap.set('n', '<leader>Ff', '<cmd>Telescope<cr>', { desc = 'builtin' })

  vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'symbols' })

  vim.keymap.set('n', '<leader>wf', '<cmd>Telescope resession<cr>', { desc = 'find_session' })

  vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'marks' })

  vim.keymap.set('n', '<leader>fr', function()
    builtin.oldfiles { only_cwd = true }
  end, { desc = 'recents' })

  vim.keymap.set('n', '<leader>f"', builtin.registers, { desc = 'registers' })
  vim.keymap.set('n', '<leader>fh', function()
    -- Prefer unsaved buffers
    builtin.buffers {
      sort_buffers = function(buf_a, buf_b)
        local a_unsaved = vim.bo[buf_a].modified
        local b_unsaved = vim.bo[buf_b].modified
        if a_unsaved ~= b_unsaved then
          return a_unsaved
        end
        return buf_a < buf_b
      end,
    }
  end, { desc = 'buffers' })
  -- vim.keymap.set("n", "<leader>fp", "<cmd>Telescope yank_history<cr>")
  -- TODO: use string instead to prevent loading extensions?
  -- vim.keymap.set({ "n", "x" }, "<leader>rr", function()
  --   require("telescope").extensions.refactoring.refactors()
  -- end)

  vim.keymap.set('n', '<leader>wc', function()
    builtin.find_files {
      prompt_title = 'Workspace Configuration',
      hidden = true,
      search_dirs = { '.vscode' },
    }
  end, { desc = 'configuration' })
end

M.setup = function()
  local action_layout = require 'telescope.actions.layout'

  local open_with_trouble = function(opts)
    require('trouble.sources.telescope').open(opts)
  end

  local add_to_trouble = function(opts)
    require('trouble.sources.telescope').add(opts)
  end

  default_opts = {
    follow = true,
    path_display = { filename_first = { reverse_directories = true } },
    preview = {
      filesize_limit = 0.5, -- MB
    },
    mappings = {
      n = {
        ['<M-p>'] = action_layout.toggle_preview,
        ['<C-q>'] = open_with_trouble,
        ['<M-q>'] = add_to_trouble,
      },
      i = {
        ['<M-p>'] = action_layout.toggle_preview,
        ['<C-q>'] = open_with_trouble,
        ['<M-q>'] = add_to_trouble,
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
      git_diffs = {
        git_command = { 'git', 'log', '--oneline', '--decorate', '--all', '.' },
      },
      resession = {
        prompt_title = 'Find Sessions',
        dir = 'session',
      },
    },
  }

  _G.loaded_telescope_extension = false
  require('telescope').load_extension 'fzf'
  require('telescope').load_extension 'git_diffs'
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
