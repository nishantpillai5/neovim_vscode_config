local starts_with = require('common.utils').starts_with

local M = {}

M.keys = {
  { '<leader>zr', desc = 'reset_ui' },
  { '<leader>zx', desc = 'close_ui' },
  { '<leader>zo', desc = 'close_panel' },
  { '<leader>ex', desc = 'close_sidebar' },
  { '<leader>ze', desc = 'close_sidebar' },
}

local settings = {
  bottom_height = 0.2,
  bottom_height_2 = 0.25,

  left_width = 0.1,
  left_width_2 = 0.15,
  left_width_3 = 0.2,

  right_width = 0.15,
  right_width_2 = 0.2,
}

local bottom = {
  {
    title = 'Git (Fugitive)',
    ft = 'fugitive',
    size = { height = settings.bottom_height },
  },
  {
    title = 'REPL (DAP)',
    ft = 'dap-repl',
    size = { height = settings.bottom_height_2 },
  },
  {
    title = 'Console (DAP)',
    ft = 'dapui_console',
    size = { height = settings.bottom_height_2 },
  },
  {
    title = 'Diagnostics (Trouble)',
    ft = 'trouble',
    size = { height = settings.bottom_height },
    filter = function(_, win)
      return vim.w[win].trouble and starts_with(vim.w[win].trouble.mode, 'diagnostics')
    end,
  },
  {
    title = 'List (Trouble)',
    ft = 'trouble',
    size = { height = settings.bottom_height },
    filter = function(_, win)
      return vim.w[win].trouble and (vim.w[win].trouble.mode == 'loclist' or vim.w[win].trouble.mode == 'quickfix')
    end,
  },
  {
    title = 'Preview (Trouble)',
    ft = 'trouble',
    size = { height = settings.bottom_height_2 },
    filter = function(_, win)
      return vim.w[win].trouble and vim.w[win].trouble_preview
    end,
  },
}

local left = {
  {
    title = 'Explorer (Neotree)',
    ft = 'neo-tree',
    size = { width = settings.left_width_2 },
  },
  {
    title = 'Symbols (Vista)',
    ft = 'vista',
    size = { width = settings.left_width_2 },
  },
  {
    title = 'Scopes (DAP)',
    ft = 'dapui_scopes',
    size = { width = settings.left_width_3 },
  },
  {
    title = 'Breakpoints (DAP)',
    ft = 'dapui_breakpoints',
    size = { width = settings.left_width_3 },
  },
  {
    title = 'Stacks (DAP)',
    ft = 'dapui_stacks',
    size = { width = settings.left_width_3 },
  },
  {
    title = 'Watches (DAP)',
    ft = 'dapui_watches',
    size = { width = settings.left_width_3 },
  },
  {
    title = 'Calendar',
    ft = 'calendar',
    size = { width = settings.left_width },
  },
}

local right = {
  {
    title = 'Tasks (Overseer)',
    ft = 'OverseerList',
    size = { width = settings.right_width },
  },
  {
    title = 'Tests (Neotest)',
    ft = 'neotest-summary',
    size = { width = settings.right_width_2 },
  },
  {
    title = 'LSP (Trouble)',
    ft = 'trouble',
    size = { width = settings.right_width_2 },
    filter = function(_, win)
      return vim.w[win].trouble and (starts_with(vim.w[win].trouble.mode, 'lsp') and not vim.w[win].trouble_preview)
    end,
  },
  {
    title = 'Telescope (Trouble)',
    ft = 'trouble',
    size = { width = settings.right_width_2 },
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
}

local right_and_left = vim.deepcopy(right)
vim.list_extend(right_and_left, left)

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>zx', function()
    require('edgy').close()
  end)

  set_keymap('n', '<leader>zo', function()
    require('edgy').close 'bottom'
  end)

  set_keymap('n', '<leader>ex', function()
    require('edgy').close(require('common.env').SIDEBAR_POSITION)
  end)

  set_keymap('n', '<leader>ze', function()
    require('edgy').close(require('common.env').SIDEBAR_POSITION)
  end)
end

M.setup = function()
  ---@diagnostic disable-next-line: missing-fields
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
      ['<leader>zr'] = function(win)
        win.view.edgebar:equalize()
      end,
    },
    bottom = bottom,
    left = require('common.env').SIDEBAR_POSITION == 'left' and left or {},
    right = require('common.env').SIDEBAR_POSITION == 'left' and right or right_and_left,
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
