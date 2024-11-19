---@diagnostic disable: missing-fields
local M = {}

local function is_notes_dir()
  return vim.fn.getcwd() == require('common.env').DIR_NOTES
end

M.keys = {
  { '<leader>nf', ':ObsidianQuickSwitch<cr>', desc = 'find' },
  { '<leader>fn', ':ObsidianQuickSwitch<cr>', desc = 'notes' },
  { '<leader>n?', ':ObsidianSearch<cr>', desc = 'search' },
  { '<leader>nJ', ':ObsidianToday<cr>', desc = 'journal_today' },
  { '<leader>nj', ':ObsidianDailies<cr>', desc = 'journal_list' },
  { '<leader>nl', ':ObsidianLinks<cr>', desc = 'links' },
  { '<leader>nL', ':ObsidianBacklinks<cr>', desc = 'backlinks' },
  { '<leader>nr', ':ObsidianRename<cr>', desc = 'rename' },
  { '<leader>np', ':ObsidianPasteImg<cr>', desc = 'paste_img' },
  { '<leader>nc', ':ObsidianNew<cr>', desc = 'create' },
  { '<leader>nC', ':ObsidianNewFromTemplate<cr>', desc = 'create_from_template' },
  { '<leader>nt', ':ObsidianTags<cr>', desc = 'tags' },
  { '<leader>ni', ':ObsidianTemplate<cr>', desc = 'insert_template' },

  { '<leader>nl', ':ObsidianLink<cr>', desc = 'link_existing', mode = { 'v' } },
  { '<leader>nL', ':ObsidianLinkNew<cr>', desc = 'link_create', mode = { 'v' } },
  { '<leader>nc', ':ObsidianExtractNote<cr>', desc = 'create', mode = { 'v' } },
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
    set_keymap('n', '<leader>ff', ':ObsidianQuickSwitch<cr>')
    set_keymap('n', '<leader>?', ':ObsidianSearch<cr>')
    set_keymap('n', '<leader>fs', ':ObsidianTOC<cr>')
    set_keymap('n', '<leader>fS', ':ObsidianTags<cr>')
  end
end

M.setup = function()
  local obsidian = require 'obsidian'

  obsidian.setup {
    ui = {
      enable = true,
      checkboxes = {
        [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
        ['x'] = { char = '󰄵', hl_group = 'ObsidianDone' },
      },
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
    mappings = {
      ['gf'] = {
        action = function()
          return obsidian.util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true, desc = 'file(obsidian)' },
      },
      ['<cr>'] = {
        action = function()
          return obsidian.util.smart_action()
        end,
        opts = { expr = true, buffer = true, desc = 'smart_action(obsidian)' },
      },
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
