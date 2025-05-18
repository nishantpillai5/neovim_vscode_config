local M = {}

M.event = {
  'BufReadPre ' .. vim.fn.expand(require('common.env').DIR_LEET .. '/**/*'),
  'BufNewFile ' .. vim.fn.expand(require('common.env').DIR_LEET .. '/**/*'),
}

M.cmd = {
  'CompetiTest',
}

M.keys = {
  { '<leader>;;', '<cmd>CompetiTest run<cr>', desc = 'run' },
  { '<leader>;t', '<cmd>CompetiTest add_testcase<cr>', desc = 'add_testcase' },
  { '<leader>;T', '<cmd>CompetiTest edit_testcase<cr>', desc = 'edit_testcase' },
  { '<leader>;l', '<cmd>CompetiTest receive problem<cr>', desc = 'load_problem' },
  { '<leader>;L', '<cmd>CompetiTest receive testcases<cr>', desc = 'load_testcases' },
  { '<leader>;y', desc = 'yank' },
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

  set_keymap('n', '<leader>;y', yank_code)
end

M.setup = function()
  ---@diagnostic disable-next-line: missing-fields
  require('competitest').setup {
    testcases_use_single_file = true,
    evaluate_template_modifiers = true,
    template_file = require('common.env').DIR_LEET .. '/templates/file.$(FEXT)',
    received_problems_prompt_path = false,
    received_contests_prompt_directory = false,
    received_contests_prompt_extension = false,
    open_received_problems = true,
    open_received_contests = true,
    save_current_file = true,
    save_all_files = false,
    ---@diagnostic disable-next-line: missing-fields
    picker_ui = {
      mappings = {
        focus_next = { 'j', '<down>', '<Tab>' },
        focus_prev = { 'k', '<up>', '<S-Tab>' },
        close = { '<esc>', '<C-c>', 'q', 'Q', 'x', 'X' },
        submit = '<cr>',
      },
    },
    ---@diagnostic disable-next-line: missing-fields
    runner_ui = {
      interface = 'split',
      mappings = {
        run_again = 'r',
        run_all_again = 'R',
        kill = 'q',
        kill_all = 'Q',
        view_input = { 'i', 'I' },
        view_output = { 'a', 'A' },
        view_stdout = { 'o', 'O' },
        view_stderr = { 'e', 'E' },
        toggle_diff = { 'd', 'D' },
        close = { 'x', 'X', 'q', 'Q' },
      },
    },
    ---@diagnostic disable-next-line: missing-fields
    split_ui = {
      position = 'right',
      relative_to_editor = true,
      -- FIXME: vertical bar for list of testcases
      vertical_layout = {
        { 2, 'tc' },
        { 3, {
          { 1, 'so' },
          { 1, 'si' },
        } },
        { 3, {
          { 1, 'eo' },
          { 1, 'se' },
        } },
      },
      horizontal_layout = {
        { 2, 'tc' },
        { 3, {
          { 1, 'so' },
          { 1, 'si' },
        } },
        { 3, {
          { 1, 'eo' },
          { 1, 'se' },
        } },
      },
    },
  }
end

local function update_competitest_winbar(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local winid = vim.fn.win_findbuf(bufnr)[1]
  if vim.bo[bufnr].filetype == 'CompetiTest' then
    local ok, title = pcall(vim.api.nvim_buf_get_var, bufnr, 'competitest_title')
    if ok and title then
        vim.api.nvim_set_option_value("winbar", title, { scope = "local", win = winid })
    end
  end
end

M.config = function()
  M.setup()
  M.keymaps()

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'CompetiTest',
    callback = function(args)
      vim.defer_fn(function()
        local bufnr = args.buf
        update_competitest_winbar(bufnr)
      end, 500) -- wait for CompetiTest to load
    end,
  })
end

-- M.config()

return M
