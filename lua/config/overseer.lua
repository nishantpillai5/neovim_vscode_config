local M = {}

M.cmd = { 'OverseerList' }

M.keys = {
  { '<leader>oo', desc = 'run_from_list' },
  { '<leader>eo', desc = 'tasks' },
  { '<leader>oc', desc = 'change_last' },
  { '<leader>ol', desc = 'restart_last' },
  { '<leader>op', desc = 'preview_last' },
  { '<leader>ox', desc = 'stop_last' },
  { '<leader>oX', desc = 'stop_all' },
  { '<leader>or', desc = 'run' },
  { '<leader>ob', desc = 'build' },
  { '<leader>oss', desc = 'save_last' },
  { '<leader>osl', desc = 'load_bundle' },
  { '<leader>osd', desc = 'delete_bundle' },
}

local action_on_all_tasks = function(action)
  local overseer = require 'overseer'
  local tasks = overseer.list_tasks { recent_first = true }
  if vim.tbl_isempty(tasks) then
    vim.notify('No tasks found', vim.log.levels.WARN)
  else
    for _, task in ipairs(tasks) do
      overseer.run_action(task, action)
    end
  end
end

local action_on_last_task = function(action)
  local overseer = require 'overseer'
  local tasks = overseer.list_tasks { recent_first = true }
  if vim.tbl_isempty(tasks) then
    vim.notify('No tasks found', vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], action)
  end
end

local panel_align = function()
  local align = require('common.env').PANEL_POSITION
  local cr_align = (align == 'vertical') and 'OpenVsplit' or 'OpenSplit'
  return cr_align
end

local toggle_sidebar = function()
  vim.cmd 'OverseerToggle'
end

local open_sidebar = function()
  vim.cmd 'OverseerOpen'
  -- focus back to the previous window
  vim.cmd 'wincmd p'
end

local get_cmd = function(task)
  if type(task.cmd) == 'string' then
    return task.cmd
  end
  return table.concat(task.cmd, ' ')
end

local filter_build_tasks = function(task)
  return string.find(string.lower(get_cmd(task)), 'build') ~= nil
end

local last_task_text = function()
  local status_symbols = {
    RUNNING = '  ',
    SUCCESS = '  ',
    CANCELED = ' 󰜺 ',
    FAILURE = '  ',
    DEFAULT = '  ',
  }

  local overseer = require 'overseer'
  local tasks = overseer.list_tasks {
    recent_first = true,
    filter = filter_build_tasks,
  }
  if vim.tbl_isempty(tasks) then
    return ''
  else
    local status_symbol = status_symbols[tasks[1].status] or status_symbols.DEFAULT
    return status_symbol .. get_cmd(tasks[1])
  end
end

M.keymaps = function()
  local overseer = require 'overseer'

  vim.keymap.set('n', '<leader>oo', function()
    vim.cmd 'OverseerRun'
  end, { desc = 'run_from_list' })

  vim.keymap.set('n', '<leader>eo', toggle_sidebar, { desc = 'tasks' })

  vim.keymap.set('n', '<leader>oc', function()
    action_on_last_task(nil)
  end, { desc = 'change_last' })

  vim.keymap.set('n', '<leader>ol', function()
    action_on_last_task 'restart'
  end, { desc = 'restart_last' })

  vim.keymap.set('n', '<leader>op', function()
    action_on_last_task 'open float'
  end, { desc = 'preview_last' })

  vim.keymap.set('n', '<leader>ox', function()
    action_on_last_task 'stop'
  end, { desc = 'stop_last' })

  vim.keymap.set('n', '<leader>oX', function()
    action_on_all_tasks 'stop'
  end, { desc = 'stop_all' })

  vim.keymap.set('n', '<leader>or', function()
    if _G.run_cmd == nil then
      vim.notify('Run Command not set', vim.log.levels.ERROR)
    else
      vim.cmd('OverseerRunCmd ' .. _G.run_cmd)
    end
  end, { desc = 'run' })

  vim.keymap.set('n', '<leader>ob', function()
    if _G.build_template == nil then
      vim.notify('Build template not set', vim.log.levels.ERROR)
    else
      overseer.run_template(_G.build_template)
    end
  end, { desc = 'build' })

  vim.keymap.set('n', '<leader>oss', function()
    action_on_last_task 'save'
  end, { desc = 'save_last' })

  vim.keymap.set('n', '<leader>osl', function()
    vim.ui.select(overseer.list_task_bundles(), {
      prompt = 'Load bundle',
      telescope = require('telescope.themes').get_cursor(),
    }, function(selected)
      if selected == nil then
        return
      end
      vim.cmd('OverseerLoadBundle ' .. selected)
    end)
  end, { desc = 'load_bundle' })

  vim.keymap.set('n', '<leader>osd', function()
    vim.ui.select(overseer.list_task_bundles(), {
      prompt = 'Delete bundle',
      telescope = require('telescope.themes').get_cursor(),
    }, function(selected)
      if selected == nil then
        return
      end
      vim.cmd('OverseerDeleteBundle ' .. selected)
    end)
  end, { desc = 'delete_bundle' })

  vim.api.nvim_create_user_command('OverseerList', function()
    vim.notify(vim.inspect(overseer.list_tasks()[1]))
  end, {})
end

M.setup = function()
  local align = panel_align()

  require('overseer').setup {
    strategy = {
      'toggleterm',
      open_on_start = false,
    },
    dap = false,
    task_list = {
      default_detail = 2,
      width = 0.13,
      bindings = {
        ['<C-h>'] = false,
        ['<C-j>'] = false,
        ['<C-k>'] = false,
        ['<C-l>'] = false,
        ['L'] = 'IncreaseDetail',
        ['H'] = 'DecreaseDetail',
        ['v'] = 'OpenVsplit',
        ['s'] = 'OpenSplit',
        ['<CR>'] = align,
        ['c'] = 'RunAction',
        ['d'] = 'Dispose',
        ['j'] = 'NextTask',
        ['k'] = 'PrevTask',
        ['x'] = 'Stop', --FIXME: doesn't work
        ['r'] = 'Restart', --FIXME: doesn't work
      },
    },
    component_aliases = {
      default_neotest = {
        'on_output_summarize',
        'on_exit_set_status',
        'on_complete_notify',
        'on_complete_dispose',
      },
    },
  }

  -- FIXME: broken with dependent task queues
  -- open sidebar when any task is started
  -- require('overseer').add_template_hook({ name = '.*' }, function(_, _)
  --   open_sidebar()
  -- end)
end

M.lualine = function()
  local lualineX = require('lualine').get_config().tabline.lualine_x or {}
  if _G.last_task_text then
    table.insert(lualineX, _G.last_task_text)
  else
    table.insert(lualineX, last_task_text)
  end
  table.insert(lualineX, { 'overseer' })

  require('lualine').setup {
    extensions = { 'overseer', 'nvim-dap-ui' },
    tabline = { lualine_x = lualineX },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
  M.lualine()
end

-- M.config()

return M
