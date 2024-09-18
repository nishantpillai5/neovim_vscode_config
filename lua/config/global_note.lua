local M = {}

local cwd_project_name = function()
  local project_directory, err = vim.loop.cwd()
  if project_directory == nil then
    vim.notify(err, vim.log.levels.WARN)
    return nil
  end

  local project_name = vim.fs.basename(project_directory)
  if project_name == nil then
    vim.notify('Unable to get the project name', vim.log.levels.WARN)
    return nil
  end

  return project_name
end

local git_project_name = function()
  local result = vim
    .system({
      'git',
      'rev-parse',
      '--show-toplevel',
    }, {
      text = true,
    })
    :wait()

  if result.stderr ~= '' then
    vim.notify(result.stderr, vim.log.levels.WARN)
    return nil
  end

  local project_directory = result.stdout:gsub('\n', '')

  local project_name = vim.fs.basename(project_directory)
  if project_name == nil then
    vim.notify('Unable to get the project name', vim.log.levels.WARN)
    return nil
  end

  return project_name
end

local branch_project_name = function()
  local result = vim
    .system({
      'git',
      'symbolic-ref',
      '--short',
      'HEAD',
    }, {
      text = true,
    })
    :wait()

  if result.stderr ~= '' then
    vim.notify(result.stderr, vim.log.levels.WARN)
    return nil
  end

  return result.stdout:gsub('\n', '')
end

M.keys = {
  { '<leader>nn', desc = 'current' },
  { '<leader>na', desc = 'all' },
  { '<leader>ng', desc = 'git_branch' },
}

M.keymaps = function()
  local global_note = require 'global-note'

  vim.keymap.set('n', '<leader>nn', function()
    global_note.toggle_note 'project_local'
  end, { desc = 'current' })

  vim.keymap.set('n', '<leader>ng', function()
    global_note.toggle_note 'git_branch_local'
  end, { desc = 'git_branch' })

  vim.keymap.set('n', '<leader>na', global_note.toggle_note, { desc = 'all' })
end

M.setup = function()
  local global_note = require 'global-note'
  local DIR_NOTES = require('common.env').DIR_NOTES
  local get_project_name = cwd_project_name
  local get_git_branch = branch_project_name

  global_note.setup {
    filename = 'current.md',
    directory = DIR_NOTES,
    title = 'GLOBAL NOTE',
    additional_presets = {
      project_local = {
        command_name = 'PROJECT NOTE',
        filename = function()
          return 'current_' .. get_project_name() .. '.md'
        end,

        title = 'Project note',
      },
      git_branch_local = {
        command_name = 'GIT BRANCH NOTE',

        directory = function()
          return vim.fn.stdpath 'data' .. '/global-note/' .. get_project_name()
        end,

        filename = function()
          local git_branch = get_git_branch()
          if git_branch == nil then
            return nil
          end
          return get_git_branch():gsub('[^%w-]', '-') .. '.md'
        end,

        title = get_git_branch,
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
