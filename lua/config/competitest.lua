local M = {}

M.cmd = {
  'CompetiTest',
}

M.keys = {
  { '<leader>Or', '<cmd>CompetiTest run<cr>', desc = 'run' },
  { '<leader>Ot', '<cmd>CompetiTest add_testcase<cr>', desc = 'add_testcase' },
  { '<leader>OT', '<cmd>CompetiTest edit_testcase<cr>', desc = 'edit_testcase' },
  { '<leader>Ol', '<cmd>CompetiTest receive problem<cr>', desc = 'load_problem' },
  { '<leader>OL', '<cmd>CompetiTest receive testcases<cr>', desc = 'load_testcases' },
  { '<leader>Oy', desc = 'yank' },
}

local yank_code = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local commentstring = vim.bo[bufnr].commentstring or '# %s'
  local comment_pat = '^%s*' .. vim.pesc(commentstring:match '^(.-)%%s') -- extract comment leader
  local start_idx = 1
  for i, line in ipairs(lines) do
    if not line:match(comment_pat) and not line:match '^%s*$' then
      start_idx = i
      break
    end
  end
  local yank_lines = {}
  for i = start_idx, #lines do
    table.insert(yank_lines, lines[i])
  end
  vim.fn.setreg('+', table.concat(yank_lines, '\n'))
  vim.notify('Yanked file content after comments to clipboard', vim.log.levels.INFO)
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>Oy', yank_code)
end

M.setup = function()
  local template_filepath = require('common.env').DIR_LEET .. '/templates/file.'
  local fts = { 'c', 'cpp', 'py' }

  local template_file = {}
  for _, ft in ipairs(fts) do
    template_file[ft] = template_filepath .. ft
  end

  ---@diagnostic disable-next-line: missing-fields
  require('competitest').setup {
    testcases_use_single_file = true,
    evaluate_template_modifiers = true,
    template_file = template_file,
    received_problems_prompt_path = false,
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
