---@diagnostic disable: missing-parameter
_G.loaded_telescope_extension = _G.loaded_telescope_extension or false

local utils = require 'common.utils'

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

local function live_grep_static_file_list(opts, file_list)
  local builtin = require 'telescope.builtin'
  opts = opts or {}
  opts.cwd = utils.get_root_dir()
  local cmd_opts, dir_opts
  opts, cmd_opts, dir_opts = require('config.neoscopes').constrain_to_scope(opts)

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

local function trim_git_modification_indicator(cmd_output)
  return cmd_output:match '[^%s]+$'
end

local live_grep_changed_files = function(opts)
  local plenary_ok, PlenaryJob = pcall(require, 'plenary.job')
  if not plenary_ok then
    vim.notify 'plenary not found'
    return
  end

  local file_list = {}
  PlenaryJob:new({
    command = 'git',
    args = { 'status', '--porcelain', '-u' },
    cwd = utils.get_root_dir(),
    on_exit = function(job)
      for _, cmd_output in ipairs(job:result()) do
        table.insert(file_list, '--glob')
        table.insert(file_list, trim_git_modification_indicator(cmd_output))
      end
    end,
  }):sync()

  live_grep_static_file_list(opts, file_list)
end

-- FIXME: broken
local live_grep_changed_files_from = function(branch, opts)
  local plenary_ok, PlenaryJob = pcall(require, 'plenary.job')
  if not plenary_ok then
    vim.notify 'plenary not found'
    return
  end
  local file_list = {}
  PlenaryJob:new({
    command = 'git',
    args = { 'diff', '--name-only', branch .. '..HEAD' },
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

local live_grep_changed_files_from_main = function(opts)
  live_grep_changed_files_from(utils.get_main_branch(), opts)
end

local live_grep_changed_files_from_branch = function(opts)
  local builtin = require 'telescope.builtin'
  builtin.git_branches {
    attach_mappings = function(_, map)
      local select_branch = function(prompt_bufnr)
        local action_state = require 'telescope.actions.state'
        local branch = action_state.get_selected_entry().name
        require('telescope.actions').close(prompt_bufnr)
        live_grep_changed_files_from(branch, opts)
      end
      map('i', '<CR>', select_branch)
      map('n', '<CR>', select_branch)
      return true
    end,
  }
end

local is_inside_work_tree = {}
-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local project_files = function()
  local builtin = require 'telescope.builtin'
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

local entry_maker = function(entry)
  local cwd = vim.fn.getcwd()
  local full_path = cwd .. '/' .. entry
  return {
    value = entry,
    display = entry,
    ordinal = entry,
    filename = full_path,
  }
end

local changed_files = function()
  local previewers = require 'telescope.previewers'
  local pickers = require 'telescope.pickers'
  local sorters = require 'telescope.sorters'
  local finders = require 'telescope.finders'

  pickers
    .new({
      prompt_title = 'Changed files',
      finder = finders.new_oneshot_job({
        'git',
        'diff',
        '--name-only',
        '--diff-filter=ACMR',
        '--relative',
        'HEAD',
      }, { entry_maker = entry_maker }),
      sorter = sorters.get_fuzzy_file(),
      previewer = previewers.new_termopen_previewer {
        get_command = function(entry)
          return {
            'git',
            '-c',
            'delta.side-by-side=false',
            'diff',
            '--diff-filter=ACMR',
            '--relative',
            'HEAD',
            '--',
            entry.value,
          }
        end,
      },
    })
    :find()
end

local changed_files_from = function(branch)
  local previewers = require 'telescope.previewers'
  local pickers = require 'telescope.pickers'
  local sorters = require 'telescope.sorters'
  local finders = require 'telescope.finders'

  local merge_base = vim.fn.system('git merge-base HEAD ' .. branch):gsub('%s+', '')

  pickers
    .new({
      prompt_title = 'Changed files from ' .. branch,
      finder = finders.new_oneshot_job({
        'git',
        'diff',
        '--name-only',
        '--diff-filter=ACMR',
        '--relative',
        merge_base,
      }, { entry_maker = entry_maker }),
      sorter = sorters.get_fuzzy_file(),
      previewer = previewers.new_termopen_previewer {
        get_command = function(entry)
          return {
            'git',
            '-c',
            'core.pager=delta',
            '-c',
            'delta.side-by-side=false',
            'diff',
            '--diff-filter=ACMR',
            '--relative',
            merge_base,
            '--',
            entry.value,
          }
        end,
      },
    })
    :find()
end

local changed_files_from_main = function()
  changed_files_from(utils.get_main_branch())
end

local changed_files_from_branch = function()
  require('telescope.builtin').git_branches {
    attach_mappings = function(_, map)
      local select_branch = function(prompt_bufnr)
        local action_state = require 'telescope.actions.state'
        local branch = action_state.get_selected_entry().name
        require('telescope.actions').close(prompt_bufnr)
        changed_files_from(branch)
      end
      map('i', '<CR>', select_branch)
      map('n', '<CR>', select_branch)
      return true
    end,
  }
end

local reset_file_to = function(branch)
  local file = vim.fn.expand '%:p'
  local cmd = 'Git checkout ' .. branch .. ' -- ' .. file
  vim.cmd(cmd)
end

local reset_file_to_fork = function()
  local merge_base = vim.fn.system('git merge-base HEAD ' .. utils.get_main_branch()):gsub('%s+', '')
  reset_file_to(merge_base)
end

local reset_file_to_main = function()
  reset_file_to(utils.get_main_branch())
end

local reset_file_to_branch = function()
  require('telescope.builtin').git_branches {
    attach_mappings = function(_, map)
      local select_branch = function(prompt_bufnr)
        local action_state = require 'telescope.actions.state'
        local branch = action_state.get_selected_entry().name
        require('telescope.actions').close(prompt_bufnr)
        reset_file_to(branch)
      end
      map('i', '<CR>', select_branch)
      map('n', '<CR>', select_branch)
      return true
    end,
  }
end

------------------------------------------------ Public ------------------------------------------------

local M = {}

M.keys = {
  { '<leader>:', desc = 'find_commands' },
  { '<leader>ff', desc = 'git_files' },
  { '<leader>fF', desc = 'ignored_files' },
  { '<leader>fa', desc = 'all' },
  { '<leader>fA', desc = 'alternate' },
  { '<leader>fgj', desc = 'changed_files' },
  { '<leader>fgk', desc = 'changed_files_from_main' },
  { '<leader>fgl', desc = 'changed_files_from_branch' },
  { '<leader>fgb', desc = 'branch_checkout' },
  { '<leader>fgB', desc = 'branch_checkout_local' },
  { '<leader>fgc', desc = 'commits_checkout' },
  { '<leader>fgC', desc = 'commits_diff' },
  { '<leader>fgz', desc = 'stash' },
  { '<leader>fgx', desc = 'conflicts' },
  { '<leader>fgJ', desc = 'live_grep_changed_files' },
  { '<leader>fgK', desc = 'live_grep_changed_files_from_main' },
  { '<leader>fgL', desc = 'live_grep_changed_files_from_branch' },
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
  { '<leader>wc', desc = 'configurations' },
  { '<leader>f=', desc = 'spellcheck' },
  { '<leader>gRj', desc = 'reset_file_to_fork' },
  { '<leader>gRk', desc = 'reset_file_to_main' },
  { '<leader>gRl', desc = 'reset_file_to_branch' },
}

M.keymaps = function()
  local builtin = require 'telescope.builtin'
  local set_keymap = utils.get_keymap_setter(M.keys)

  set_keymap('n', '<leader>:', builtin.commands)
  set_keymap('n', '<leader>ff', project_files)

  set_keymap('n', '<leader>fF', function()
    local prefix = require('common.env').USER_PREFIX .. '_'
    builtin.find_files { default_text = prefix, no_ignore = true }
  end)

  set_keymap('n', '<leader>fa', builtin.find_files)

  set_keymap('n', '<leader>fA', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local basename = vim.fn.fnamemodify(bufname, ':t:r'):lower()
    builtin.git_files { default_text = basename }
  end)

  set_keymap('n', '<leader>fgj', changed_files)
  set_keymap('n', '<leader>fgk', changed_files_from_main)
  set_keymap('n', '<leader>fgl', changed_files_from_branch)
  set_keymap('n', '<leader>fgb', builtin.git_branches)
  set_keymap('n', '<leader>fgB', function()
    builtin.git_branches { show_remote_tracking_branches = false }
  end)
  set_keymap('n', '<leader>fgc', builtin.git_bcommits)
  set_keymap('n', '<leader>fgC', require('telescope').extensions.git_diffs.diff_commits)
  set_keymap('n', '<leader>fgz', builtin.git_stash)
  set_keymap('n', '<leader>fgx', '<cmd>Telescope conflicts<cr>')

  set_keymap('n', '<leader>fgJ', live_grep_changed_files)
  set_keymap('n', '<leader>fgK', live_grep_changed_files_from_main)
  set_keymap('n', '<leader>fgL', live_grep_changed_files_from_branch)

  set_keymap('n', '<leader>gRj', reset_file_to_fork)
  set_keymap('n', '<leader>gRk', reset_file_to_main)
  set_keymap('n', '<leader>gRl', reset_file_to_branch)

  set_keymap('n', '<leader>ft', function()
    live_grep_changed_files_from_main { default_text = require('common.env').TODO_CUSTOM .. ':' }
  end, { desc = 'todos_in_branch(' .. require('common.env').TODO_CUSTOM .. ')' })

  set_keymap('n', '<leader>fl', builtin.live_grep)

  set_keymap('n', '<leader>fL', function()
    require('telescope').extensions.live_grep_args.live_grep_args()
  end)

  set_keymap('n', '<leader>/', function()
    vim.cmd 'Telescope current_buffer_fuzzy_find'
  end)

  set_keymap('n', '<leader>?', function()
    builtin.grep_string { search = vim.fn.input 'Search > ' }
  end)

  set_keymap('n', '<leader>fw', function()
    local word = vim.fn.expand '<cword>'
    builtin.grep_string { search = word }
  end)

  set_keymap('n', '<leader>fW', function()
    local word = vim.fn.expand '<cWORD>'
    builtin.grep_string { search = word }
  end)

  set_keymap('n', '<leader>Ff', '<cmd>Telescope<cr>')
  set_keymap('n', '<leader>fs', builtin.lsp_document_symbols)
  set_keymap('n', '<leader>wf', '<cmd>Telescope resession<cr>')
  set_keymap('n', '<leader>fm', builtin.marks)
  set_keymap('n', '<leader>fr', function()
    builtin.oldfiles { only_cwd = true }
  end)

  set_keymap('n', '<leader>f"', builtin.registers)
  set_keymap('n', '<leader>fh', function()
    builtin.buffers {
      sort_buffers = function(buf_a, buf_b)
        -- Prefer unsaved buffers
        local a_unsaved = vim.bo[buf_a].modified
        local b_unsaved = vim.bo[buf_b].modified
        if a_unsaved ~= b_unsaved then
          return a_unsaved
        end
        return buf_a < buf_b
      end,
    }
  end)

  set_keymap('n', '<leader>wc', function()
    builtin.find_files {
      prompt_title = 'Workspace Configuration',
      hidden = true,
      no_ignore = true,
      no_ignore_parent = true,
      search_dirs = { '.vscode' },
      find_command = { 'fd', '--follow', '--exclude', '.git' },
    }
  end)

  set_keymap('n', '<leader>f=', builtin.spell_suggest)
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
  local actions = require 'telescope.actions'
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
            ['<C-i>'] = lga_actions.quote_prompt { postfix = ' --iglob **' },
            ['<C-f>'] = actions.to_fuzzy_refine,
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
