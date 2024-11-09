local M = {}

M.keys = {
  { '<leader>zp', desc = 'preview' },
}

M.keymaps = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'quarto',
    callback = function()
      vim.keymap.set(
        'n',
        '<leader>zp',
        require('quarto').quartoPreview,
        { silent = true, noremap = true, buffer = true, desc = 'preview(quarto)' }
      )

      local runner = require 'quarto.runner'
      vim.keymap.set('n', '<leader>ij', runner.run_below, { desc = 'run_below(quarto)', silent = true })
      vim.keymap.set('n', '<leader>ik', runner.run_above, { desc = 'run_above(quarto)', silent = true })
      vim.keymap.set('n', '<leader>ii', runner.run_cell, { desc = 'run_cell(quarto)', silent = true })
      vim.keymap.set('n', '<leader>iI', runner.run_all, { desc = 'run_all(quarto)', silent = true })

      vim.keymap.set('v', '<leader>ii', runner.run_range, { desc = 'run(quarto)', silent = true })
      vim.keymap.set('n', '<leader>il', runner.run_line, { desc = 'run_line(quarto)', silent = true })
    end,
  })
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

-- keys = {
--   { '<leader>qa', ':QuartoActivate<cr>', desc = 'quarto activate' },
--   { '<leader>qp', ":lua require'quarto'.quartoPreview()<cr>", desc = 'quarto preview' },
--   { '<leader>qq', ":lua require'quarto'.quartoClosePreview()<cr>", desc = 'quarto close' },
--   { '<leader>qh', ':QuartoHelp ', desc = 'quarto help' },
--   { '<leader>qe', ":lua require'otter'.export()<cr>", desc = 'quarto export' },
--   { '<leader>qE', ":lua require'otter'.export(true)<cr>", desc = 'quarto export overwrite' },
--   { '<leader>qrr', ':QuartoSendAbove<cr>', desc = 'quarto run to cursor' },
--   { '<leader>qra', ':QuartoSendAll<cr>', desc = 'quarto run all' },
--   { '<leader><cr>', ':SlimeSend<cr>', desc = 'send code chunk' },
--   { '<c-cr>', ':SlimeSend<cr>', desc = 'send code chunk' },
--   { '<c-cr>', '<esc>:SlimeSend<cr>i', mode = 'i', desc = 'send code chunk' },
--   { '<c-cr>', '<Plug>SlimeRegionSend<cr>', mode = 'v', desc = 'send code chunk' },
--   { '<cr>', '<Plug>SlimeRegionSend<cr>', mode = 'v', desc = 'send code chunk' },
--   { '<leader>ctr', ':split term://R<cr>', desc = 'terminal: R' },
--   { '<leader>cti', ':split term://ipython<cr>', desc = 'terminal: ipython' },
--   { '<leader>ctp', ':split term://python<cr>', desc = 'terminal: python' },
--   { '<leader>ctj', ':split term://julia<cr>', desc = 'terminal: julia' },
-- },
-- opts = {
--   lspFeatures = {
--     languages = { 'r', 'python', 'julia', 'bash', 'html', 'lua' },
--   },
-- },
