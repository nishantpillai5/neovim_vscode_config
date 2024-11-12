local M = {}

M.keys = {
  { '<leader>z=', desc = 'equalize_panels' },
  { '<leader>zx', desc = 'close_panels' },
  { '<leader>ex', desc = 'close_explorers' },
}

--TODO: Fix resizing when not inside edgy panel
local widescreen_settings = {
  BOTTOM_HEIGHT = 0.2,
  LEFT_WIDTH = 0.1,
  RIGHT_WIDTH = 0.15,
  BOTTOM_HEIGHT_2 = 0.25,
  DAP_LEFT_WIDTH_2 = 0.2,
  RIGHT_WIDTH_2 = 0.2,
  LEFT_WIDTH_2 = 0.15,
}

local normal_settings = {
  -- FIXME: same
  BOTTOM_HEIGHT = 0.2,
  LEFT_WIDTH = 0.1,
  RIGHT_WIDTH = 0.15,
  BOTTOM_HEIGHT_2 = 0.25,
  DAP_LEFT_WIDTH_2 = 0.2,
  RIGHT_WIDTH_2 = 0.2,
  LEFT_WIDTH_2 = 0.15,
}
local settings = require('common.env').SCREEN == 'widescreen' and widescreen_settings or normal_settings

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)
  set_keymap('n', '<leader>zx', function()
    require('edgy').close()
  end)

  set_keymap('n', '<leader>ex', function()
    require('edgy').close 'left'
  end)
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
        size = { height = settings.BOTTOM_HEIGHT },
      },
      {
        title = 'REPL (DAP)',
        ft = 'dap-repl',
        size = { height = settings.BOTTOM_HEIGHT_2 },
      },
      {
        title = 'Console (DAP)',
        ft = 'dapui_console',
        size = { height = settings.BOTTOM_HEIGHT_2 },
      },
      {
        title = 'Diagnostics (Trouble)',
        ft = 'trouble',
        size = { height = settings.BOTTOM_HEIGHT },
        filter = function(_, win)
          return vim.w[win].trouble and starts_with(vim.w[win].trouble.mode, 'diagnostics')
        end,
      },
      {
        title = 'List (Trouble)',
        ft = 'trouble',
        size = { height = settings.BOTTOM_HEIGHT },
        filter = function(_, win)
          return vim.w[win].trouble and (vim.w[win].trouble.mode == 'loclist' or vim.w[win].trouble.mode == 'quickfix')
        end,
      },
      {
        title = 'Preview (Trouble)',
        ft = 'trouble',
        size = { height = settings.BOTTOM_HEIGHT_2 },
        filter = function(_, win)
          return vim.w[win].trouble and vim.w[win].trouble_preview
        end,
      },
    },
    left = {
      {
        title = 'Explorer (Neotree)',
        ft = 'neo-tree',
        size = { width = settings.LEFT_WIDTH_2 },
      },
      {
        title = 'Symbols (Vista)',
        ft = 'vista',
        size = { width = settings.LEFT_WIDTH_2 },
      },
      {
        title = 'Scopes (DAP)',
        ft = 'dapui_scopes',
        size = { width = settings.DAP_LEFT_WIDTH_2 },
      },
      {
        title = 'Breakpoints (DAP)',
        ft = 'dapui_breakpoints',
        size = { width = settings.DAP_LEFT_WIDTH_2 },
      },
      {
        title = 'Stacks (DAP)',
        ft = 'dapui_stacks',
        size = { width = settings.DAP_LEFT_WIDTH_2 },
      },
      {
        title = 'Watches (DAP)',
        ft = 'dapui_watches',
        size = { width = settings.DAP_LEFT_WIDTH_2 },
      },
      {
        title = 'Calendar',
        ft = 'calendar',
        size = { width = settings.LEFT_WIDTH },
      },
    },
    right = {
      {
        title = 'Tasks (Overseer)',
        ft = 'OverseerList',
        size = { width = settings.RIGHT_WIDTH },
      },
      {
        title = 'Tests (Neotest)',
        ft = 'neotest-summary',
        size = { width = settings.RIGHT_WIDTH_2 },
      },
      {
        title = 'LSP (Trouble)',
        ft = 'trouble',
        size = { width = settings.RIGHT_WIDTH_2 },
        filter = function(_, win)
          return vim.w[win].trouble and (starts_with(vim.w[win].trouble.mode, 'lsp') and not vim.w[win].trouble_preview)
        end,
      },
      {
        title = 'Telescope (Trouble)',
        ft = 'trouble',
        size = { width = settings.RIGHT_WIDTH_2 },
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
