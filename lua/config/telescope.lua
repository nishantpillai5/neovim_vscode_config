---@diagnostic disable: missing-parameter
_G.loaded_telescope_extension = _G.loaded_telescope_extension or false

local utils = require 'common.utils'

local MAX_GREPPED_FILES = 500 -- The limitation is due to command-line length.

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
  vimgrep_arguments = utils.merge_list(vimgrep_arguments, cmd_opts)
  opts.vimgrep_arguments = vimgrep_arguments

  opts.search_dirs = opts.search_dirs or {}
  opts.search_dirs = utils.merge_list(opts.search_dirs, dir_opts)
  -- FIXME: remove files outside scope, and add icon
  opts.search_dirs = utils.merge_list(opts.search_dirs, file_list)

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
  ---@diagnostic disable-next-line: missing-fields
  PlenaryJob:new({
    command = 'git',
    args = { 'status', '--porcelain', '-u' },
    cwd = utils.get_root_dir(),
    on_exit = function(job)
      for _, cmd_output in ipairs(job:result()) do
        table.insert(file_list, trim_git_modification_indicator(cmd_output))
      end
    end,
  }):sync()

  opts = opts or {}
  opts.prompt_title = 'Live Grep Changed Files from HEAD'
  live_grep_static_file_list(opts, file_list)
end

local live_grep_changed_files_from = function(ref, opts)
  local plenary_ok, PlenaryJob = pcall(require, 'plenary.job')
  if not plenary_ok then
    vim.notify 'plenary not found'
    return
  end
  local file_list = {}
  ---@diagnostic disable-next-line: missing-fields
  PlenaryJob:new({
    command = 'git',
    args = { 'diff', '--name-only', ref .. '..HEAD' },
    cwd = utils.get_root_dir(),
    on_exit = function(job)
      for _, cmd_output in ipairs(job:result()) do
        table.insert(file_list, cmd_output)
      end
    end,
  }):sync()
  local max_files = MAX_GREPPED_FILES
  if #file_list > max_files then
    vim.notify(
      'Too many files (' .. #file_list .. '). This operation might fail, limiting to first ' .. max_files,
      vim.log.levels.WARN
    )
    file_list = vim.list_slice(file_list, 1, max_files)
  end
  live_grep_static_file_list(opts, file_list)
end

local live_grep_changed_files_from_fork = function(opts)
  opts = opts or {}
  opts.prompt_title = 'Live Grep Changed Files from Fork'
  live_grep_changed_files_from(utils.get_fork_point(), opts)
end

local live_grep_changed_files_from_main = function(opts)
  opts = opts or {}
  local main_branch = utils.get_main_branch()
  opts.prompt_title = 'Live Grep Changed Files from ' .. main_branch
  live_grep_changed_files_from(main_branch, opts)
end

local live_grep_changed_files_from_branch = function(opts)
  opts = opts or {}
  local builtin = require 'telescope.builtin'
  builtin.git_branches {
    attach_mappings = function(_, map)
      local select_branch = function(prompt_bufnr)
        local action_state = require 'telescope.actions.state'
        local branch = action_state.get_selected_entry().name
        require('telescope.actions').close(prompt_bufnr)
        opts.prompt_title = 'Live Grep Changed Files from ' .. branch
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

local changed_files_from = function(ref)
  local previewers = require 'telescope.previewers'
  local pickers = require 'telescope.pickers'
  local sorters = require 'telescope.sorters'
  local finders = require 'telescope.finders'
  local action_state = require 'telescope.actions.state'

  pickers
    .new({
      prompt_title = 'Changed files from ' .. ref,
      finder = finders.new_oneshot_job({
        'git',
        'diff',
        '--name-only',
        '--diff-filter=ACMR',
        '--relative',
        ref,
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
            ref,
            '--',
            entry.value,
          }
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        map({ 'i', 'n' }, '<C-i>', function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          picker:refresh(
            finders.new_oneshot_job({
              'git',
              'ls-files',
              '--others',
              '--exclude-standard',
            }, { entry_maker = entry_maker }),
            { reset_prompt = false }
          )
        end, { desc = 'include_untracked_files' })
        return true
      end,
    })
    :find()
end

-- TODO: This function is slower since it runs two separate git commands
local slower_changed_files_from = function(ref, include_untracked)
  include_untracked = include_untracked or false
  local previewers = require 'telescope.previewers'
  local pickers = require 'telescope.pickers'
  local sorters = require 'telescope.sorters'
  local finders = require 'telescope.finders'
  local action_state = require 'telescope.actions.state'

  local function get_diff_files()
    local handle = io.popen(string.format('git diff --name-only --diff-filter=ACMR --relative %s', ref))
    if not handle then
      return {}
    end
    local result = {}
    for line in handle:lines() do
      table.insert(result, line)
    end
    handle:close()
    return result
  end

  local function get_untracked_files()
    local handle = io.popen 'git ls-files --others --exclude-standard'
    if not handle then
      return {}
    end
    local result = {}
    for line in handle:lines() do
      table.insert(result, line)
    end
    handle:close()
    return result
  end

  local files
  if include_untracked then
    local diff_files = get_diff_files()
    local untracked_files = get_untracked_files()
    local seen = {}
    files = {}
    for _, f in ipairs(diff_files) do
      if not seen[f] then
        table.insert(files, f)
        seen[f] = true
      end
    end
    for _, f in ipairs(untracked_files) do
      if not seen[f] then
        table.insert(files, f)
        seen[f] = true
      end
    end
  else
    files = get_diff_files()
  end

  pickers
    .new({
      prompt_title = 'Changed files from ' .. ref .. ' (including untracked)',
      finder = finders.new_table {
        results = files,
        entry_maker = entry_maker,
      },
      sorter = sorters.get_fuzzy_file(),
      previewer = previewers.new_termopen_previewer {
        get_command = function(entry)
          return { 'cat', entry.value }
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        map({ 'i', 'n' }, '<C-i>', function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          local diff_files = get_diff_files()
          local untracked_files = get_untracked_files()
          local seen = {}
          local all_files = {}
          for _, f in ipairs(diff_files) do
            if not seen[f] then
              table.insert(all_files, f)
              seen[f] = true
            end
          end
          for _, f in ipairs(untracked_files) do
            if not seen[f] then
              table.insert(all_files, f)
              seen[f] = true
            end
          end
          picker:refresh(
            finders.new_table {
              results = all_files,
              entry_maker = entry_maker,
            },
            { reset_prompt = false }
          )
        end, { desc = 'include_untracked_files' })
        return true
      end,
    })
    :find()
end

local changed_files = function()
  changed_files_from 'HEAD'
end

local changed_files_with_untracked = function()
  slower_changed_files_from('HEAD', true)
end

local changed_files_from_fork = function()
  changed_files_from(utils.get_fork_point())
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

local reset_file_to = function(ref)
  local file = vim.fn.expand '%:p'
  local cmd = 'Git checkout ' .. ref .. ' -- ' .. file
  vim.cmd(cmd)
end

local reset_file_to_fork = function()
  reset_file_to(utils.get_fork_point())
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

M.cmd = {
  'Telescope',
}

M.keys = {
  { '<leader>:', desc = 'find_commands' },
  { '<leader>ff', desc = 'git_files' },
  { '<leader>fF', desc = 'ignored_files' },
  { '<leader>fa', desc = 'all' },
  { '<leader>fA', desc = 'alternate' },
  { '<leader>fi', desc = 'files_from_head_include_untracked' },
  { '<leader>fj', desc = 'files_from_head' },
  { '<leader>fk', desc = 'files_from_fork' },
  { '<leader>fl', desc = 'files_from_main' },
  { '<leader>f;', desc = 'files_from_branch' },
  { '<leader>fJ', desc = 'grep_from_head' },
  { '<leader>fK', desc = 'grep_from_fork' },
  { '<leader>fL', desc = 'grep_from_main' },
  { '<leader>f:', desc = 'grep_from_branch' },
  { '<leader>fgb', desc = 'branch_checkout' },
  { '<leader>fgB', desc = 'branch_checkout_local' },
  { '<leader>fgc', desc = 'commits_checkout' },
  { '<leader>fgC', desc = 'commits_diff' },
  { '<leader>fgz', desc = 'stash' },
  { '<leader>gzf', desc = 'find' },
  { '<leader>fgx', desc = 'conflicts' },
  { '<leader>gJ', desc = 'grep_from_head' },
  { '<leader>gK', desc = 'grep_from_fork' },
  { '<leader>gL', desc = 'grep_from_main' },
  { '<leader>g:', desc = 'grep_from_branch' },
  { '<leader>ft', desc = 'todos_in_fork' },
  { '<leader>f/', desc = 'live_grep_global' },
  { '<leader>f?', desc = 'live_grep_global_with_args' },
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
  { '<leader>wc', desc = 'local_config' },
  { '<leader>f=', desc = 'spellcheck' },
  { '<leader>gRk', desc = 'reset_file_to_fork' },
  { '<leader>gRl', desc = 'reset_file_to_main' },
  { '<leader>gR;', desc = 'reset_file_to_branch' },
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

  set_keymap('n', '<leader>fi', changed_files_with_untracked)
  set_keymap('n', '<leader>fj', changed_files)
  set_keymap('n', '<leader>fk', changed_files_from_fork)
  set_keymap('n', '<leader>fl', changed_files_from_main)
  set_keymap('n', '<leader>f;', changed_files_from_branch)

  set_keymap('n', '<leader>fJ', live_grep_changed_files)
  set_keymap('n', '<leader>fK', live_grep_changed_files_from_fork)
  set_keymap('n', '<leader>fL', live_grep_changed_files_from_main)
  set_keymap('n', '<leader>f:', live_grep_changed_files_from_branch)

  set_keymap('n', '<leader>fgb', builtin.git_branches)
  set_keymap('n', '<leader>fgB', function()
    builtin.git_branches { show_remote_tracking_branches = false }
  end)
  set_keymap('n', '<leader>fgc', builtin.git_bcommits)
  set_keymap('n', '<leader>fgC', require('telescope').extensions.git_diffs.diff_commits)
  set_keymap('n', '<leader>fgz', builtin.git_stash)
  set_keymap('n', '<leader>gzf', builtin.git_stash)
  set_keymap('n', '<leader>fgx', '<cmd>Telescope conflicts<cr>')

  set_keymap('n', '<leader>gJ', live_grep_changed_files)
  set_keymap('n', '<leader>gK', live_grep_changed_files_from_fork)
  set_keymap('n', '<leader>gL', live_grep_changed_files_from_main)
  set_keymap('n', '<leader>g:', live_grep_changed_files_from_branch)

  set_keymap('n', '<leader>gRk', reset_file_to_fork)
  set_keymap('n', '<leader>gRl', reset_file_to_main)
  set_keymap('n', '<leader>gR;', reset_file_to_branch)

  set_keymap('n', '<leader>ft', function()
    live_grep_changed_files_from_fork { default_text = require('common.env').TODO_CUSTOM .. ':' }
  end, { desc = 'todos_in_fork(' .. require('common.env').TODO_CUSTOM .. ')' })

  set_keymap('n', '<leader>f/', builtin.live_grep)

  set_keymap('n', '<leader>f?', function()
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
  local lga_actions = require 'telescope-live-grep-args.actions'
  local actions = require 'telescope.actions'

  local open_with_trouble = function(opts)
    require('trouble.sources.telescope').open(opts)
  end

  local add_to_trouble = function(opts)
    require('trouble.sources.telescope').add(opts)
  end

  local yank_name = function(prompt_bufnr)
    local action_state = require 'telescope.actions.state'
    local entry = action_state.get_selected_entry()
    if entry then
      vim.fn.setreg('+', entry.value)
      vim.notify('Copied : ' .. entry.value, vim.log.levels.INFO)
    end
    actions.close(prompt_bufnr)
  end

  default_opts = {
    follow = true,
    path_display = { filename_first = { reverse_directories = true } },
    preview = {
      filesize_limit = 0.5, -- MB
    },
    mappings = {
      n = {
        ['p'] = action_layout.toggle_preview,
        ['T'] = open_with_trouble,
        ['t'] = add_to_trouble,
        ['y'] = yank_name,
      },
    },
  }

  require('telescope').setup {
    defaults = default_opts,
    pickers = {
      find_files = default_opts,
      live_grep = default_opts,
      grep_string = default_opts,
      git_files = default_opts,
      git_branches = {
        mappings = {
          i = {
            ['<cr>'] = actions.git_switch_branch,
          },
          n = {
            ['<cr>'] = actions.git_switch_branch,
            ['d'] = actions.git_delete_branch,
            ['R'] = actions.git_rebase_branch,
            ['r'] = actions.git_rename_branch,
            ['m'] = actions.git_merge_branch,
            ['c'] = actions.git_checkout,
            ['C'] = actions.git_create_branch,
            ['p'] = action_layout.toggle_preview,
            ['y'] = yank_name,
          },
        },
      },
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
