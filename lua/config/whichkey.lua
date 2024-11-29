local M = {}

M.keys = {
  {
    '<leader><leader>',
    function()
      require('which-key').show { global = true }
    end,
    desc = 'whichkey_help',
  },
}

M.init = function()
  vim.o.timeout = true
  vim.o.timeoutlen = 300
end

M.spec = {
  { '<leader>', group = 'Leader' },
  { '<leader>;', group = 'Terminal' },
  { '<leader>b', group = 'Breakpoint' },
  { '<leader>c', group = 'Chat', mode = { 'n', 'v' } },
  { '<leader>e', group = 'Explorer' },
  { '<leader>ey', group = 'Yank' },
  { '<leader>f', group = 'Find', mode = { 'n', 'v' } },
  { '<leader>fg', group = 'Git' },
  { '<leader>fb', group = 'Breakpoint' },
  { '<leader>F', group = 'Find_Telescope' },
  { '<leader>gc', group = 'Debugrint' },
  { '<leader>g', group = 'Git', mode = { 'n', 'v' } },
  { '<leader>gh', group = 'Hunk', mode = { 'n', 'v' } },
  { '<leader>go', group = 'Open', mode = { 'n', 'v' } },
  { '<leader>gx', group = 'Conflict' },
  { '<leader>gz', group = 'Stash' },
  { '<leader>l', group = 'LSP', mode = { 'n', 'v' } },
  { '<leader>i', group = 'Test', mode = { 'n', 'v' } },
  { '<leader>n', group = 'Notes', mode = { 'n', 'v' } },
  { '<leader>o', group = 'Tasks' },
  { '<leader>os', group = 'Save' },
  { '<leader>r', group = 'Refactor' },
  { '<leader>t', group = 'Trouble' },
  { '<leader>w', group = 'Workspace' },
  { '<leader>z', group = 'Visual', mode = { 'n', 'v' } },
  { '<leader>zo', group = 'Run' },
  { '<leader>zh', group = 'Highlight', mode = { 'n', 'v' } },
  { ']', group = 'Next' },
  { '[', group = 'Prev' },

  { ']d', desc = 'diagnostic' },
  { '[d', desc = 'diagnostic' },

  { 'm', group = 'Marks' },
  { 'z', group = 'Fold' },

  { '<C-h>', desc = 'move_focus_left' },
  { '<C-j>', desc = 'move_focus_down' },
  { '<C-k>', desc = 'move_focus_up' },
  { '<C-l>', desc = 'move_focus_right' },

  { 'gd', desc = 'definition' },
  { 'gD', desc = 'declaration' },
  { 'gi', desc = 'implementation' },
  { 'go', desc = 'symbol' },
  { 'gr', desc = 'references' },
  { 'gh', desc = 'signature_help' },
  { 'gl', desc = 'diagnostics' },
  { 'g?', desc = 'debugprint' },

  { 'K', desc = 'hover' },
  { 's', desc = 'hop_char' },
  { 'S', desc = 'hop_node' },

  { '<F2>', desc = 'rename' },
  { '<F3>', desc = 'format_lsp' },
  { '<F4>', desc = 'code_action' },
}

M.setup = function()
  local wk = require 'which-key'
  wk.setup {
    icons = { rules = false },
    triggers = {
      { '<auto>', mode = 'nixsotc' },
      { 'm', mode = { 'n', 'v' } },
    },
    sort = { 'local', 'order', 'group', 'alphanum', 'mod', 'lower', 'icase' },
    spec = M.spec,
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
