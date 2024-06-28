local M = {}

M.leader_maps = {
  name = 'Shortcuts',
  [';'] = 'Terminal',
  b = 'Breakpoint',
  c = 'Chat',
  e = { name = 'Explorer', y = 'Yank' },
  f = { name = 'Find', g = 'Git', b = 'Breakpoint' },
  F = 'Find_Telescope',
  g = { name = 'Git', h = 'Hunk', o = 'Open' },
  l = 'LSP',
  n = 'Notes',
  o = 'Tasks',
  r = 'Refactor',
  t = 'Trouble',
  w = 'Workspace',
  z = 'Visual',
}

return M
