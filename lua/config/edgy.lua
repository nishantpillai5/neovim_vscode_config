local M = {}

M.keys = {
  { '<leader>z=', desc = 'equalize_panels' },
  { '<leader>zx', desc = 'close_panels' },
  { '<leader>ex', desc = 'close_explorers' },
}

M.keymaps = function()
  vim.keymap.set('n', '<leader>zx', function()
    require('edgy').close()
  end, { desc = 'close_panels' })

  vim.keymap.set('n', '<leader>ex', function()
    require('edgy').close 'left'
  end, { desc = 'close_explorers' })
end

M.setup = function()
  require('edgy').setup {
    exit_when_last = true,
    animate = { enabled = false },
    wo = {
      winhighlight = '',
    },
    keys = {
      -- TODO: bind <leader>zx to close all
      ['<C-Right>'] = function(win)
        win:resize('width', 2)
      end,
      ['<C-Left>'] = function(win)
        win:resize('width', -2)
      end,
      ['<C-Up>'] = function(win)
        win:resize('height', 2)
      end,
      ['<C-Down>'] = function(win)
        win:resize('height', -2)
      end,
      -- FIXME: this doesn't work

      -- ['<leader>z='] = function(win)
      --   win.view.edgebar:equalize()
      -- end,
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
  M.keymaps()
end

-- M.config()

return M
