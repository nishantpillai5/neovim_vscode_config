local M = {}

M.ft = { 'markdown', 'quarto' }

M.keys = {
  -- { '<leader>zp', desc = 'preview' },
  { '<leader>wi', desc = 'kernel_select' },
}

local set_run_keymaps = function()
  local runner = require 'quarto.runner'
  vim.keymap.set('n', '<leader>ij', runner.run_below, { desc = 'run_below(quarto)', silent = true })
  vim.keymap.set('n', '<leader>ik', runner.run_above, { desc = 'run_above(quarto)', silent = true })
  vim.keymap.set('n', '<leader>ii', runner.run_cell, { desc = 'run_cell(quarto)', silent = true })
  vim.keymap.set('n', '<leader>iI', runner.run_all, { desc = 'run_all(quarto)', silent = true })

  vim.keymap.set('v', '<leader>ii', runner.run_range, { desc = 'run(quarto)', silent = true })
  vim.keymap.set('n', '<leader>il', runner.run_line, { desc = 'run_line(quarto)', silent = true })
end

local set_preview_keymaps = function()
  vim.keymap.set(
    'n',
    '<leader>zp',
    require('quarto').quartoPreview,
    { silent = true, noremap = true, buffer = true, desc = 'preview(quarto)' }
  )
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
