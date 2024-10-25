local M = {}

local explain_prompt = 'Write a concise explanation for the active selection. Don\'t explain everything in the code, just the functionality as a whole'
local simplify_prompt = 'Simplify and improve readablilty'
local fix_prompt =
  'There is a problem in this code. Explain what the problem is and then rewrite the code with the bug fixed. Only generate code that needs to be changed.'
local pr_prompt =
  'Generate a list of bullet points for a PR description that reflects the changes made. The points should be concise, clear and should reflect the change in functionality rather than the minor details. The PR description should begin with Changes:'

-- find other default prompts here
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/canary/lua/CopilotChat/prompts.lua
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/canary/lua/CopilotChat/config.lua

-- TODO: add exclude dirs (journal) and files (todo.md, readme)
-- TODO: add mapping to disable/enable copilot
-- TODO: role based prompts cR (https://github.com/abelberhane/GPT-Scripts/tree/main/role-prompting)

M.keys = {
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

M.keymaps = function()
  local actions = require 'CopilotChat.actions'
  local select = require 'CopilotChat.select'

  vim.keymap.set('n', '<leader>cc', function()
    vim.cmd 'CopilotChatToggle'
  end, { desc = 'toggle' })

  -- Built-in

  vim.keymap.set({ 'n', 'v' }, '<leader>ce', function()
    vim.cmd 'CopilotChatExplain'
  end, { desc = 'explain' })

  vim.keymap.set({ 'n', 'v' }, '<leader>co', function()
    vim.cmd 'CopilotChatOptimize'
  end, { desc = 'optimize' })

  vim.keymap.set({ 'n', 'v' }, '<leader>cd', function()
    vim.cmd 'CopilotChatFixDiagnostic'
  end, { desc = 'diagnostic_fix' })

  -- TODO: select from a list of frameworks and make the prompt "Please generate tests for my code using the framework <framework>"
  vim.keymap.set({ 'n', 'v' }, '<leader>cD', function()
    vim.cmd 'CopilotChatDocs'
  end, { desc = 'docs' })

  vim.keymap.set({ 'n', 'v' }, '<leader>cg', function()
    vim.cmd 'CopilotChatCommit'
  end, { desc = 'commit' })

  vim.keymap.set({ 'n', 'v' }, '<leader>cG', function()
    vim.cmd 'CopilotChatCommitStaged'
  end, { desc = 'commit_staged' })

  vim.keymap.set({ 'n', 'v' }, '<leader>cr', function()
    vim.cmd 'CopilotChatReview'
  end, { desc = 'review' })

  vim.keymap.set({ 'n', 'v' }, '<leader>ct', function()
    vim.cmd 'CopilotChatTests'
  end, { desc = 'tests' })

  vim.keymap.set('n', '<leader>cx', function()
    vim.cmd 'CopilotChatStop'
  end, { desc = 'stop' })

  vim.keymap.set('n', '<leader>cX', function()
    vim.cmd 'CopilotChatReset'
  end, { desc = 'reset' })

  -- Custom

  vim.keymap.set('n', '<leader>cb', function()
    local input = vim.fn.input 'Quick Chat: '
    if input ~= '' then
      require('CopilotChat').ask(input, { selection = select.buffer })
    end
  end, { desc = 'buffer' })

  vim.keymap.set('v', '<leader>cc', function()
    local input = vim.fn.input 'Quick Chat: '
    if input ~= '' then
      require('CopilotChat').ask(input, { select.selection })
    end
  end, { desc = 'selection' })

  vim.keymap.set('v', '<leader>cs', function()
    require('CopilotChat').ask(simplify_prompt, { selection = select.selection })
  end, { desc = 'simplify' })

  -- TODO: gitdiff from master instead of local
  vim.keymap.set('n', '<leader>cp', function()
    require('CopilotChat').ask(pr_prompt, { selection = select.gitdiff })
  end, { desc = 'pr_changes' })

  -- Telescope

  vim.keymap.set({ 'n', 'v' }, '<leader>fc', function()
    require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
  end, { desc = 'chat' })

  vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
    require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
  end, { desc = 'find' })
end

M.setup = function()
  require('CopilotChat').setup {
    show_help = true,
    debug = false,
    disable_extra_info = 'no',
    auto_follow_cursor = false, -- Auto-follow cursor in chat
    insert_at_end = true,
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

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'copilot-*',
    callback = function()
      -- C-p to print last response
      vim.keymap.set('n', '<C-p>', function()
        print(require('CopilotChat').response())
      end, { buffer = true, remap = true })
    end,
  })
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
