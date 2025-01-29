local M = {}

local explain_prompt =
  "Write a concise explanation for the active selection. Don't explain everything in the code, just the functionality as a whole"
local simplify_prompt = 'Simplify and improve readablilty'
local fix_prompt =
  'There is a problem in this code. Explain what the problem is and then rewrite the code with the bug fixed. Only generate code that needs to be changed.'
local pr_prompt =
  'Generate a list of bullet points for a PR description that reflects the changes made. The points should be concise, clear and should reflect the change in functionality rather than the minor details. The PR description should begin with Changes:'
local attach_selection_prompt = 'Attach the selected code to the chat. Only reply with "CONTEXT RECEIVED"'

-- find other default prompts here
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/canary/lua/CopilotChat/prompts.lua
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/canary/lua/CopilotChat/config.lua

M.keys = {
  { '<leader>ca', desc = 'attach_selection', mode = 'v' },
  { '<leader>cA', desc = 'attach_file', mode = 'v' },
  { '<leader>cc', mode = 'n', desc = 'chat' },
  { '<leader>ce', mode = { 'n', 'v' }, desc = 'explain' },
  { '<leader>co', mode = { 'n', 'v' }, desc = 'optimize' },
  { '<leader>cd', mode = { 'n', 'v' }, desc = 'diagnostic_fix' },
  { '<leader>cD', mode = { 'n', 'v' }, desc = 'docs' },
  { '<leader>cg', mode = { 'n', 'v' }, desc = 'commit' },
  { '<leader>cG', mode = { 'n', 'v' }, desc = 'commit_staged' },
  { '<leader>cr', mode = { 'n', 'v' }, desc = 'review' },
  { '<leader>ct', mode = { 'n', 'v' }, desc = 'tests' },
  { '<leader>cx', desc = 'stop' },
  { '<leader>cX', desc = 'reset' },
  { '<leader>cb', desc = 'buffer' },
  { '<leader>cc', mode = 'v', desc = 'selection' },
  { '<leader>cs', mode = 'v', desc = 'simplify' },
  { '<leader>cp', mode = 'n', desc = 'pr_changes' },
  { '<leader>fc', mode = { 'n', 'v' }, desc = 'chat' },
  { '<leader>cf', mode = { 'n', 'v' }, desc = 'find' },
}

M.buffer_keys = {
  '<C-p>',
  desc = 'print_last_response',
}

M.keymaps = function()
  local copilot = require 'CopilotChat'
  local actions = require 'CopilotChat.actions'
  local select = require 'CopilotChat.select'
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  local default_selection = function(source)
    return select.visual(source) or select.buffer(source)
  end

  local buffer_selection = function(source)
    return select.visual(source) or select.buffer(source)
  end

  local visual_selection = function(source)
    return select.visual(source)
  end

  set_keymap('n', '<leader>cc', function()
    vim.cmd 'CopilotChatToggle'
  end)

  -- Built-in
  set_keymap({ 'n', 'v' }, '<leader>ce', function()
    vim.cmd 'CopilotChatExplain'
  end)

  set_keymap({ 'n', 'v' }, '<leader>co', function()
    vim.cmd 'CopilotChatOptimize'
  end)

  set_keymap({ 'n', 'v' }, '<leader>cd', function()
    vim.cmd 'CopilotChatFixDiagnostic'
  end)

  set_keymap({ 'n', 'v' }, '<leader>cD', function()
    vim.cmd 'CopilotChatDocs'
  end)

  set_keymap({ 'n', 'v' }, '<leader>cg', function()
    vim.cmd 'CopilotChatCommit'
  end)

  set_keymap({ 'n', 'v' }, '<leader>cG', function()
    vim.cmd 'CopilotChatCommitStaged'
  end)

  set_keymap({ 'n', 'v' }, '<leader>cr', function()
    vim.cmd 'CopilotChatReview'
  end)

  -- TODO: select from a list of frameworks and make the prompt "Please generate tests for my code using the framework <framework>"
  set_keymap({ 'n', 'v' }, '<leader>ci', function()
    vim.cmd 'CopilotChatTests'
  end)

  set_keymap('n', '<leader>cx', function()
    vim.cmd 'CopilotChatStop'
  end)

  set_keymap('n', '<leader>cX', function()
    vim.cmd 'CopilotChatReset'
  end)

  -- Custom
  set_keymap('n', '<leader>cb', function()
    local input = vim.fn.input 'Quick Chat: '
    if input ~= '' then
      copilot.ask(input, { selection = buffer_selection })
    end
  end)

  set_keymap('v', '<leader>cc', function()
    local input = vim.fn.input 'Quick Chat: '
    if input ~= '' then
      copilot.ask(input, { selection = default_selection })
    end
  end)

  set_keymap('v', '<leader>cs', function()
    copilot.ask(simplify_prompt, { selection = visual_selection })
  end)

  -- TODO: gitdiff from master instead of local
  set_keymap('n', '<leader>cp', function()
    copilot.ask(pr_prompt, { context = { 'git:staged' } })
  end)

  set_keymap('v', '<leader>ca', function()
    copilot.ask(attach_selection_prompt, { selection = visual_selection })
  end)

  set_keymap('v', '<leader>cA', function()
    copilot.ask(attach_selection_prompt, { selection = buffer_selection })
  end)

  -- Telescope
  set_keymap({ 'n', 'v' }, '<leader>fc', function()
    require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
  end)

  set_keymap({ 'n', 'v' }, '<leader>cf', function()
    require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
  end)
end

M.setup = function()
  local copilot = require 'CopilotChat'
  copilot.setup {
    show_help = true,
    debug = false,
    auto_follow_cursor = false,
    language = 'English',
    context = 'buffers',
    mappings = {
      reset = {
        normal = '<C-r>',
        insert = '<C-r>',
      },
      complete = {
        insert = '<S-Tab>',
      },
    },
    prompts = {
      Explain = {
        prompt = '/COPILOT_EXPLAIN ' .. explain_prompt,
      },
      Fix = {
        prompt = '/COPILOT_GENERATE ' .. fix_prompt,
      },
    },
  }

  local set_buf_keymap = require('common.utils').get_keymap_setter(M.buffer_keys, { buffer = true })

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'copilot-*',
    callback = function()
      set_buf_keymap('n', '<C-p>', function()
        print(copilot.response())
      end)
    end,
  })
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
