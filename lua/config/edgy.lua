local M = {}

M.keys = {
  { '<leader>z=', desc = 'equalize_windows' },
}

M.setup = function()
  require('edgy').setup {
    exit_when_last = true,
    animate = { enabled = false },
    keys = {
      -- increase width
      ['<C-Right>'] = function(win)
        win:resize('width', 2)
      end,
      -- decrease width
      ['<C-Left>'] = function(win)
        win:resize('width', -2)
      end,
      -- increase height
      ['<C-Up>'] = function(win)
        win:resize('height', 2)
      end,
      -- decrease height
      ['<C-Down>'] = function(win)
        win:resize('height', -2)
      end,
      ['<leader>z='] = function(win)
        win.view.edgebar:equalize()
      end,
    },
    bottom = {
      {
        title = 'Git',
        ft = 'fugitive',
        size = { width = 0.4 },
      },
      {
        title = 'Trouble',
        ft = 'trouble',
        size = { width = 0.4 },
      },
    },
    left = {
      {
        title = 'Explorer',
        ft = 'neo-tree',
        size = { width = 0.2 },
      },
      {
        title = 'Symbols',
        ft = 'vista',
        size = { width = 0.2 },
      },
    },
    right = {
      {
        title = 'Tasks',
        ft = 'OverseerList',
        size = { width = 0.25 },
      },
      {
        title = 'Copilot',
        ft = 'copilot-chat',
        size = { width = 0.4 },
      },
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
