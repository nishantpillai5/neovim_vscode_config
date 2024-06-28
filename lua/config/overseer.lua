local M = {}

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

local sidebar_align = function()
  local align = require('common.env').SIDEBAR_POSITION
  local force_right = require('common.env').FORCE_RIGHT_TASKS_PANEL
  if force_right then
    align = 'right'
  end
  return align
end

local panel_align = function()
  local align = require('common.env').PANEL_POSITION
  local cr_align = (align == 'vertical') and 'OpenVsplit' or 'OpenSplit'
  return cr_align
end

M.keymaps = function()
  vim.keymap.set('n', '<leader>oo', function()
    vim.cmd 'OverseerRun'
  end, { desc = 'run_from_list' })

  vim.keymap.set('n', '<leader>eo', function()
    vim.cmd('OverseerToggle ' .. sidebar_align())
  end, { desc = 'tasks' })

  vim.keymap.set('n', '<leader>ot', function()
    vim.cmd('OverseerToggle ' .. sidebar_align())
  end, { desc = 'toggle' })

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
    if _G.build_cmd == nil then
      vim.notify('Build Command not set', vim.log.levels.ERROR)
    else
      vim.cmd('OverseerRunCmd ' .. _G.build_cmd)
    end
  end, { desc = 'build' })
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
      width = 0.1,
      bindings = {
        ['L'] = 'IncreaseDetail',
        ['H'] = 'DecreaseDetail',
        ['<C-h>'] = false,
        ['<C-j>'] = false,
        ['<C-k>'] = false,
        ['<C-l>'] = false,
        ['v'] = 'OpenVsplit',
        ['s'] = 'OpenSplit',
        ['c'] = 'RunAction',
        ['<CR>'] = align,
        ['d'] = 'Dispose',
        -- ['x'] = 'Stop', --FIXME: doesn't work
      },
    },
  }
end

M.lualine = function()
  local lualineX = require('lualine').get_config().tabline.lualine_x or {}
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
