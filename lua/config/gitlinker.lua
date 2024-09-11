local M = {}

M.cmd = {
  'GitLink',
}

M.keys = {
  { '<leader>gop', '<cmd>GitLink! pr<cr>', mode = { 'n', 'v' }, desc = 'pr' },
  { '<leader>goj', '<cmd>GitLink! jira<cr>', mode = { 'n', 'v' }, desc = 'jira' },
  { '<leader>goJ', '<cmd>GitLink! jira_current<cr>', mode = { 'n', 'v' }, desc = 'jira_current' },
}

M.setup = function()
  require('gitlinker').setup(_G.gitlinker_config)
end

M.config = function()
  M.setup()
end

-- M.config()

return M
