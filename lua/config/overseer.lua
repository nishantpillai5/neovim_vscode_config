local M = {}

M.keymaps = function()
  local align = require('common.env').SIDEBAR_POSITION
  vim.keymap.set('n', '<leader>oo', function()
    vim.cmd 'OverseerRun'
  end, { desc = 'run_from_list' })

  vim.keymap.set('n', '<leader>eo', function()
    vim.cmd('OverseerToggle ' .. align)
  end, { desc = 'tasks' })

  vim.keymap.set('n', '<leader>ot', function()
    vim.cmd('OverseerToggle ' .. align)
  end, { desc = 'toggle' })

  vim.keymap.set('n', '<leader>ol', function()
    vim.cmd 'OverseerRestartLast'
  end, { desc = 'last_restart' })

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
        ['<CR>'] = 'OpenVsplit',
        ['d'] = 'Dispose',
        -- ['x'] = 'Stop', --FIXME: doesn't work
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

M.config = function()
  M.setup()
  M.keymaps()
  M.lualine()
end

-- M.config()

return M
