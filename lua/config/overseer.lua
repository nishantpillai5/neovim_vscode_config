local M = {}

M.keymaps = function()
  local align = require('common.env').ALIGN
  vim.keymap.set('n', '<leader>oo', function()
    vim.cmd 'OverseerRun'
  end, { desc = 'Tasks.run' })

  vim.keymap.set('n', '<leader>eo', function()
    vim.cmd('OverseerToggle ' .. align)
  end, { desc = 'Explorer.tasks' })

  vim.keymap.set('n', '<leader>ot', function()
    vim.cmd('OverseerToggle ' .. align)
  end, { desc = 'Tasks.toggle' })

  vim.keymap.set('n', '<leader>ol', function()
    vim.cmd 'OverseerRestartLast'
  end, { desc = 'Tasks.restart_last' })
end

M.setup = function()
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
        ['<C-l>'] = false,
        ['<C-h>'] = false,
        ["v"] = "OpenVsplit",
        ["s"] = "OpenSplit",
      },
    },
  }
  vim.api.nvim_create_user_command('OverseerRestartLast', function()
    local overseer = require 'overseer'
    local tasks = overseer.list_tasks { recent_first = true }
    if vim.tbl_isempty(tasks) then
      vim.notify('No tasks found', vim.log.levels.WARN)
    else
      overseer.run_action(tasks[1], 'restart')
    end
  end, {})
end

M.lualine = function()
  local lualineX = require('lualine').get_config().tabline.lualine_x or {}
  table.insert(lualineX, { 'overseer' })

  require('lualine').setup {
    extensions = { 'overseer', 'nvim-dap-ui' },
    tabline = { lualine_x = lualineX },
  }
end

return M
