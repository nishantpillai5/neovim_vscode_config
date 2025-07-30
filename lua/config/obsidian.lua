---@diagnostic disable: missing-fields
local M = {}

local function is_notes_dir()
  return vim.fn.getcwd() == require('common.env').DIR_NOTES
end

M.keys = {
  { '<leader>nf', ':Obsidian quick_switch<cr>', desc = 'find' },
  { '<leader>fn', ':Obsidian quick_switch<cr>', desc = 'notes' },
  { '<leader>n?', ':Obsidian search<cr>', desc = 'search' },
  { '<leader>nj', ':Obsidian today<cr>', desc = 'journal_today' },
  { '<leader>nJ', ':Obsidian dailies<cr>', desc = 'journal_list' },
  { '<leader>nl', ':Obsidian links<cr>', desc = 'links' },
  { '<leader>nL', ':Obsidian backlinks<cr>', desc = 'backlinks' },
  { '<leader>nr', ':Obsidian rename<cr>', desc = 'rename' },
  { '<leader>np', ':Obsidian paste_img<cr>', desc = 'paste_img' },
  { '<leader>nc', ':Obsidian new<cr>', desc = 'create' },
  { '<leader>nC', ':Obsidian new_from_template<cr>', desc = 'create_from_template' },
  { '<leader>nt', ':Obsidian tags<cr>', desc = 'tags' },
  { '<leader>ni', ':Obsidian template<cr>', desc = 'insert_template' },

  { '<leader>nl', ':Obsidian link<cr>', desc = 'link_existing', mode = { 'v' } },
  { '<leader>nL', ':Obsidian link_new<cr>', desc = 'link_create', mode = { 'v' } },
  { '<leader>nc', ':Obsidian extract_note<cr>', desc = 'create', mode = { 'v' } },
}

M.common_keys = {
  { '<leader>ff', desc = 'files(notes)' },
  { '<leader>?', desc = 'find_global(notes)' },
  { '<leader>fs', desc = 'symbols(notes)' },
  { '<leader>fS', desc = 'tags(notes)' },
}

M.keymaps = function()
  if is_notes_dir() then
    local set_keymap = require('common.utils').get_keymap_setter(M.common_keys)
    set_keymap('n', '<leader>ff', ':Obsidian quick_switch<cr>')
    set_keymap('n', '<leader>?', ':Obsidian search<cr>')
    set_keymap('n', '<leader>fs', ':Obsidian toc<cr>')
    set_keymap('n', '<leader>fS', ':Obsidian tags<cr>')
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'ObsidianNoteEnter',
    callback = function(ev)
      -- vim.keymap.set('n', 'gf', function()
      --   require('obsidian').util.gf_passthrough()
      -- end, {
      --   buffer = ev.buf,
      --   desc = 'file(obsidian)',
      -- })

      vim.keymap.set({ 'n', 'v' }, 'mc', ':Obsidian toggle_checkbox<cr>', {
        buffer = ev.buf,
        desc = 'smart_action(obsidian)',
        silent = true,
      })
    end,
  })
end

M.setup = function()
  local obsidian = require 'obsidian'

  obsidian.setup {
    legacy_commands = false,
    ui = {
      enable = true,
    },
    checkbox = {
      order = { ' ', 'x', '>' },
    },
    workspaces = {
      {
        name = 'notes',
        path = require('common.env').DIR_NOTES,
      },
    },
    templates = {
      folder = 'templates',
      date_format = '%Y.%m.%d.%a',
      time_format = '%H:%M',
    },
    daily_notes = {
      folder = 'journal',
      date_format = '%Y.%m.%d',
      template = 'daily.md',
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    picker = {
      name = 'telescope.nvim',
      note_mappings = {
        new = '<C-x>',
        insert_link = '<C-l>',
      },
      tag_mappings = {
        tag_note = '<C-x>',
        insert_tag = '<C-l>',
      },
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
