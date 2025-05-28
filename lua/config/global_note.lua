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
  { '<leader>nN', desc = 'note_project' },
  { '<leader>na', desc = 'note_global' },
  { '<leader>nn', desc = 'note_git_branch' },
}

M.keymaps = function()
  local global_note = require 'global-note'
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>nN', function()
    global_note.toggle_note 'project_local'
  end)

  set_keymap('n', '<leader>nn', function()
    global_note.toggle_note 'git_branch_local'
  end)

  set_keymap('n', '<leader>na', global_note.toggle_note)
end

M.setup = function()
  local global_note = require 'global-note'
  local DIR_NOTES = require('common.env').DIR_NOTES

  global_note.setup {
    filename = 'project.md',
    directory = DIR_NOTES,
    title = 'GLOBAL NOTE',
    additional_presets = {
      project_local = {
        command_name = 'PROJECT NOTE',
        filename = function()
          return 'project.' .. cwd_project_name() .. '.md'
        end,

        title = function()
          return cwd_project_name()
        end,
      },
      git_branch_local = {
        command_name = 'GIT BRANCH NOTE',
        filename = function()
          local git_branch = branch_project_name()
          if git_branch == nil then
            return nil
          end
          local git_branch_sanitized = git_branch:gsub('[^%w-]', '-')
          return 'project.' .. cwd_project_name() .. '.' .. git_branch_sanitized .. '.md'
        end,

        title = function()
          return cwd_project_name() .. ' | ' .. branch_project_name()
        end,
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
