_G.worktree_copy_items = _G.worktree_copy_items or { '.env', '.vscode' }
_G.worktree_create_callback = _G.worktree_create_callback or nil

local M = {}

M.keys = {
  { '<leader>wgs', desc = 'worktree_switch' },
  { '<leader>wgc', desc = 'worktree_create' },
  { '<leader>wgd', desc = 'worktree_delete' },
}

-- Resolve the working-tree root. git-worktree.nvim and telescope run their git
-- commands from nvim's cwd; when that cwd is inside the `.git` dir (e.g. nvim
-- launched there) `git rev-parse --show-toplevel` fails. Fall back to the
-- parent of the resolved git dir in that case.
local function worktree_root()
  local top = vim.fn.systemlist { 'git', 'rev-parse', '--show-toplevel' }
  if vim.v.shell_error == 0 and top[1] and top[1] ~= '' then
    return top[1]
  end
  local gitdir = vim.fn.systemlist { 'git', 'rev-parse', '--absolute-git-dir' }
  if vim.v.shell_error == 0 and gitdir[1] and gitdir[1] ~= '' then
    return vim.fn.fnamemodify((gitdir[1]:gsub('/$', '')), ':h')
  end
  return vim.uv.cwd() or '.'
end

-- Where a worktree named `name` lives: under .claude/worktrees inside the repo
local function worktree_dest(root, name)
  return vim.fs.joinpath(root, '.claude', 'worktrees', name)
end

-- Centered single-line input dialog. The global `vim.ui.input` provider renders
-- at the cursor; this floats in the middle of the editor instead.
local function centered_input(opts, on_submit)
  local ok, Input = pcall(require, 'nui.input')
  if not ok then
    return vim.ui.input(opts, on_submit)
  end
  local event = require('nui.utils.autocmd').event
  local title = (opts.prompt or 'Input'):gsub('%s*:%s*$', '')
  local input = Input({
    relative = 'editor',
    position = '50%',
    size = { width = math.min(60, vim.o.columns - 8) },
    border = {
      style = 'rounded',
      text = { top = ' ' .. title .. ' ', top_align = 'center' },
    },
    win_options = { winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder' },
  }, {
    default_value = opts.default or '',
    on_submit = on_submit,
  })
  input:mount()
  input:map('n', '<Esc>', function()
    input:unmount()
  end, { noremap = true })
  input:map('i', '<C-c>', function()
    input:unmount()
  end, { noremap = true })
  input:on(event.BufLeave, function()
    input:unmount()
  end)
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  local switch_worktree = function()
    require('telescope').extensions.git_worktree.git_worktree { cwd = worktree_root() }
  end

  local create_worktree = function()
    local root = worktree_root()
    centered_input({ prompt = 'New worktree name: ' }, function(name)
      name = name and vim.trim(name)
      if not name or name == '' then
        return
      end
      -- git-worktree.nvim runs every git op from nvim's cwd; point it at the
      -- working tree (not the .git dir) so `git worktree add` resolves right.
      -- The CREATE hook then switches cwd into the new worktree on success.
      vim.cmd.cd(vim.fn.fnameescape(root))
      require('git-worktree').create_worktree(worktree_dest(root, name), name)
    end)
  end

  local delete_worktree = function()
    local root = worktree_root()
    local lines = vim.fn.systemlist { 'git', '-C', root, 'worktree', 'list' }
    if vim.v.shell_error ~= 0 then
      vim.notify('Not a git repository', vim.log.levels.ERROR)
      return
    end

    local items = {}
    for _, line in ipairs(lines) do
      local path, rest = line:match '^(%S+)%s+(.*)$'
      if path and not rest:match '^%(bare%)' then
        table.insert(items, { path = path, label = line })
      end
    end
    if #items == 0 then
      vim.notify('No worktrees to delete', vim.log.levels.WARN)
      return
    end

    vim.ui.select(items, {
      prompt = 'Delete worktree',
      format_item = function(item)
        return item.label
      end,
    }, function(choice)
      if not choice then
        return
      end
      require('git-worktree').delete_worktree(choice.path, false, {
        on_success = function()
          vim.notify('Deleted worktree: ' .. choice.path)
        end,
        on_failure = function()
          vim.notify('Failed to delete ' .. choice.path .. ' (uncommitted changes or in use)', vim.log.levels.ERROR)
        end,
      })
    end)
  end

  set_keymap('n', '<leader>wgs', switch_worktree)
  set_keymap('n', '<leader>wgc', create_worktree)
  set_keymap('n', '<leader>wgd', delete_worktree)
end

M.setup = function()
  require('telescope').load_extension 'git_worktree'

  local Hooks = require 'git-worktree.hooks'
  local config = require 'git-worktree.config'

  Hooks.register(Hooks.type.CREATE, function(path, branch)
    -- vim.notify('Created: ' .. path .. '  ~>  ' .. (branch or ''))

    -- git-worktree.nvim auto-switches into the new worktree right after this
    -- hook. Stash the current cwd so the create-triggered SWITCH can bail out
    -- and leave us where we are instead of following into the new tree.
    M._stay_after_create = vim.uv.cwd()

    -- Copy local-only files (not tracked by git) into the fresh worktree so
    -- it's ready to run. The hook fires before the switch, so cwd is still the
    -- source worktree.
    local src = vim.trim(vim.fn.system { 'git', 'rev-parse', '--show-toplevel' })
    local dest = vim.fn.fnamemodify(path, ':p'):gsub('/$', '')
    if _G.worktree_copy_items and vim.v.shell_error == 0 and src ~= '' and src ~= dest then
      for _, item in ipairs(_G.worktree_copy_items) do
        local from = src .. '/' .. item
        if vim.uv.fs_stat(from) then
          vim.fn.system { 'cp', '-R', from, dest .. '/' }
          if vim.v.shell_error ~= 0 then
            vim.notify('Failed to copy ' .. item .. ' to worktree', vim.log.levels.WARN)
          end
        end
      end
    end

    if _G.worktree_create_callback ~= nil then
      _G.worktree_create_callback(path, branch)
    end
  end)

  Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
    if M._stay_after_create then
      local stay = M._stay_after_create
      M._stay_after_create = nil
      -- Undo the auto-cd into the freshly created worktree.
      vim.cmd.cd(vim.fn.fnameescape(stay))
      return
    end

    vim.notify('Moved:' .. prev_path .. '  ~>  ' .. path)

    if vim.fn.expand('%'):find '^oil:///' then
      require('oil').open(vim.fn.getcwd())
    else
      Hooks.builtins.update_current_buffer_on_switch(path, prev_path)
    end
  end)

  Hooks.register(Hooks.type.DELETE, function()
    vim.cmd(config.update_on_change_command)
  end)
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
