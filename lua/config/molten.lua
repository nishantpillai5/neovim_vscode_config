  local M = {}

M.keys = {
  { '<leader>iI', desc = 'init_molten' },
}

M.ft = { 'markdown', 'python', 'quarto' }

M.init = function()
  vim.g.molten_image_provider = 'none'
  -- vim.g.molten_image_provider = 'image.nvim'
  vim.g.molten_output_win_max_height = 20
  vim.g.molten_virt_text_output = true
  vim.g.molten_auto_open_output = false
  vim.g.molten_output_show_exec_time = true
  vim.g.molten_auto_image_popup = true
end

M.keymaps = function()
  vim.keymap.set('n', '<leader>wi', function()
    vim.cmd 'MoltenInit'
  end, { desc = 'kernel_select(quarto)', silent = true })
end

local function lualine_status()
  local icon = ' '
  local status = require 'molten.status'
  if status.initialized() == '' then
    return icon .. ''
  end
  return icon .. status.kernels()
end

M.lualine = function()
  local lualineZ = require('lualine').get_config().tabline.lualine_z or {}
  table.insert(lualineZ, { lualine_status })

  require('lualine').setup { tabline = { lualine_z = lualineZ } }
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
  M.lualine()
end

return M
