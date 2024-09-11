local M = {}

M.keys = {
  { '<C-h>', desc = 'navigate_left' },
  { '<C-j>', desc = 'navigate_down' },
  { '<C-k>', desc = 'navigate_up' },
  { '<C-l>', desc = 'navigate_right' },
  { '<C-Space>', desc = 'navigate_last_active' },
  { '<C-\\>', desc = 'navigate_next' },
}

M.keymaps = function()
  local nvim_tmux_nav = require 'nvim-tmux-navigation'
  vim.keymap.set('n', '<C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
  vim.keymap.set('n', '<C-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
  vim.keymap.set('n', '<C-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
  vim.keymap.set('n', '<C-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
  vim.keymap.set('n', '<C-Space>', nvim_tmux_nav.NvimTmuxNavigateLastActive)
  vim.keymap.set('n', '<C-\\>', nvim_tmux_nav.NvimTmuxNavigateNext)
end

M.setup = function()
  local nvim_tmux_nav = require 'nvim-tmux-navigation'
  nvim_tmux_nav.setup {
    disable_when_zoomed = true,
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
