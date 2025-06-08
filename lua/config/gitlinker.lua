_G.gitlinker_config = _G.gitlinker_config or nil

local M = {}

M.cmd = {
  'GitLink',
}

M.keys_all = {
  {
    '<leader>gop',
    '<cmd>GitLink! pr<cr>',
    mode = { 'n', 'v' },
    desc = 'pr',
    vsc_cmd = 'gitlens.openAssociatedPullRequestOnRemote',
  },
  { '<leader>goj', '<cmd>GitLink! jira<cr>', mode = { 'n', 'v' }, desc = 'jira' },
  { '<leader>goJ', '<cmd>GitLink! jira_current<cr>', mode = { 'n', 'v' }, desc = 'jira_current' },
}
M.keys = require('common.utils').filter_keymap(M.keys_all)

M.setup = function()
  require('gitlinker').setup(_G.gitlinker_config)
end

M.config = function()
  M.setup()
end

-- M.config()

return M
