local M = {}

M.ft = { 'markdown', 'quarto' }

M.keys = {
  { '<leader>wi', desc = 'kernel_select' },
}

M.buffer_keys = {
  { '<leader>ij', desc = 'quarto-run_below' },
  { '<leader>ik', desc = 'quarto-run_above' },
  { '<leader>ii', desc = 'quarto-run_cell' },
  { '<leader>iI', desc = 'quarto-run_all' },
  { '<leader>ii', desc = 'quarto-run' },
  { '<leader>il', desc = 'quarto-run_line' },
  { '<leader>zp', desc = 'quarto-preview' },
}

local set_run_keymaps = function()
  local runner = require 'quarto.runner'
  local set_keymap = require('common.utils').get_keymap_setter(M.buffer_keys, { buffer = true })

  set_keymap('n', '<leader>ij', runner.run_below)
  set_keymap('n', '<leader>ik', runner.run_above)
  set_keymap('n', '<leader>ii', runner.run_cell)
  set_keymap('n', '<leader>iI', runner.run_all)
  set_keymap('v', '<leader>ii', runner.run_range)
  set_keymap('n', '<leader>il', runner.run_line)
end

local set_preview_keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.buffer_keys, { buffer = true })
  set_keymap('n', '<leader>zp', require('quarto').quartoPreview)
end

M.keymaps = function()
  local set_keymap = require('common.utils').get_keymap_setter(M.keys)

  set_keymap('n', '<leader>wi', function()
    vim.cmd 'MoltenInit'
    -- FIXME: init local venv kernal
    -- auto select venv [link](https://github.com/benlubas/molten-nvim/blob/main/docs/Virtual-Environments.md)
    -- local venv = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX'
    -- if venv ~= nil then
    --   venv = require("common.utils").to_unix_path(venv)
    --   vim.notify('Before: ' .. venv)
    --   venv = string.match(venv, '/.+/(.+)')
    --   vim.notify('After: ', venv)
    --   vim.cmd(('MoltenInit %s'):format(venv))
    -- else
    --   vim.cmd 'MoltenInit'
    -- end
  end)

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'quarto',
    callback = set_preview_keymaps,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'quarto' },
    callback = set_run_keymaps,
  })

  -- Apply keymaps if the file is already open
  if vim.tbl_contains(M.ft, vim.bo.filetype) then
    set_run_keymaps()
    if vim.bo.filetype == 'markdown' then
      set_preview_keymaps()
    end
  end
end

M.setup = function()
  local quarto = require 'quarto'
  quarto.setup {
    debug = false,
    closePreviewOnExit = true,
    lspFeatures = {
      enabled = true,
      chunks = 'curly',
      languages = { 'r', 'python', 'julia', 'bash', 'html' },
      diagnostics = {
        enabled = true,
        triggers = { 'BufWritePost' },
      },
      completion = {
        enabled = true,
      },
    },
    codeRunner = {
      enabled = false,
      default_method = 'molten',
      ft_runners = { python = 'molten' },
      -- Takes precedence over `default_method`
      never_run = { 'yaml' },
    },
  }
end

M.config = function()
  M.setup()
  M.keymaps()
end

-- M.config()

return M
