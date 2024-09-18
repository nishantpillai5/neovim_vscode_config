local M = {}

M.keys = {
  { '<leader>z=', desc = 'equalize_panels' },
  { '<leader>zx', desc = 'close_panels' },
  { '<leader>ex', desc = 'close_explorers' },
}

--TODO: Fix resizing when not inside edgy panel

-- TODO: change this based on screen type
local BOTTOM_HEIGHT = 0.2
local LEFT_WIDTH = 0.1
local RIGHT_WIDTH = 0.15

local BOTTOM_HEIGHT_2 = 0.25
local DAP_LEFT_WIDTH_2 = 0.2
local RIGHT_WIDTH_2 = 0.2
local LEFT_WIDTH_2 = 0.15

M.keymaps = function()
  vim.keymap.set('n', '<leader>zx', function()
    require('edgy').close()
  end, { desc = 'close_panels' })

  vim.keymap.set('n', '<leader>ex', function()
    require('edgy').close 'left'
  end, { desc = 'close_explorers' })
end

M.setup = function()
  local starts_with = require('common.utils').starts_with
  require('edgy').setup {
    exit_when_last = true,
    animate = { enabled = false },
    wo = {
      winhighlight = '',
    },
    keys = {
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
        title = 'Git (Fugitive)',
        ft = 'fugitive',
        size = { height = BOTTOM_HEIGHT },
      },
      {
        title = 'REPL (DAP)',
        ft = 'dap-repl',
        size = { height = BOTTOM_HEIGHT_2 },
      },
      {
        title = 'Console (DAP)',
        ft = 'dapui_console',
        size = { height = BOTTOM_HEIGHT_2 },
      },
      {
        title = 'Diagnostics (Trouble)',
        ft = 'trouble',
        size = { height = BOTTOM_HEIGHT },
        filter = function(_, win)
          return vim.w[win].trouble and starts_with(vim.w[win].trouble.mode, 'diagnostics')
        end,
      },
      {
        title = 'List (Trouble)',
        ft = 'trouble',
        size = { height = BOTTOM_HEIGHT },
        filter = function(_, win)
          return vim.w[win].trouble and (vim.w[win].trouble.mode == 'loclist' or vim.w[win].trouble.mode == 'quickfix')
        end,
      },
      {
        title = 'Preview (Trouble)',
        ft = 'trouble',
        size = { height = BOTTOM_HEIGHT_2 },
        filter = function(_, win)
          return vim.w[win].trouble and vim.w[win].trouble_preview
        end,
      },
    },
    left = {
      {
        title = 'Explorer (Neotree)',
        ft = 'neo-tree',
        size = { width = LEFT_WIDTH_2 },
      },
      {
        title = 'Symbols (Vista)',
        ft = 'vista',
        size = { width = LEFT_WIDTH_2 },
      },
      {
        title = 'Scopes (DAP)',
        ft = 'dapui_scopes',
        size = { width = DAP_LEFT_WIDTH_2 },
      },
      {
        title = 'Breakpoints (DAP)',
        ft = 'dapui_breakpoints',
        size = { width = DAP_LEFT_WIDTH_2 },
      },
      {
        title = 'Stacks (DAP)',
        ft = 'dapui_stacks',
        size = { width = DAP_LEFT_WIDTH_2 },
      },
      {
        title = 'Watches (DAP)',
        ft = 'dapui_watches',
        size = { width = DAP_LEFT_WIDTH_2 },
      },
    },
    right = {
      {
        title = 'Tasks (Overseer)',
        ft = 'OverseerList',
        size = { width = RIGHT_WIDTH },
      },
      {
        title = 'Tests (Neotest)',
        ft = 'neotest-summary',
        size = { width = RIGHT_WIDTH_2 },
      },
      {
        title = 'LSP (Trouble)',
        ft = 'trouble',
        size = { width = RIGHT_WIDTH_2 },
        filter = function(_, win)
          return vim.w[win].trouble and (starts_with(vim.w[win].trouble.mode, 'lsp') and not vim.w[win].trouble_preview)
        end,
      },
      {
        title = 'Telescope (Trouble)',
        ft = 'trouble',
        size = { width = RIGHT_WIDTH_2 },
        filter = function(_, win)
          return vim.w[win].trouble
            and (starts_with(vim.w[win].trouble.mode, 'telescope') and not vim.w[win].trouble_preview)
        end,
      },
      -- {
      --   title = 'Copilot',
      --   ft = 'copilot-chat',
      --   size = { width = 0.4 },
      -- },
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
