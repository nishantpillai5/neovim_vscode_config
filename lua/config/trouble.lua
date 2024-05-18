local M = {}

M.keymaps = function ()
  local trouble = require('trouble')
  vim.keymap.set("n", "<leader>tt", function()
    trouble.toggle()
  end, {desc = "Trouble.toggle"})

  vim.keymap.set("n", "<leader>tw", function()
    trouble.toggle('workspace_diagnostics')
  end, {desc = "Trouble.workspace_diagnostics"})

  vim.keymap.set("n", "<leader>td", function()
    trouble.toggle('document_diagnostics')
  end, {desc = "Trouble.document_diagnostics"})

  vim.keymap.set("n", "<leader>tq", function()
    trouble.toggle('quickfix')
  end, {desc = "Trouble.quickfix"})

  vim.keymap.set("n", "<leader>tl", function()
    trouble.toggle('loclist')
  end, {desc = "Trouble.loclist"})

  vim.keymap.set("n", "]d", function()
    trouble.next({skip_groups = true, jump = true})
  end, {desc = "Next.trouble"})

  vim.keymap.set("n", "[d", function()
    trouble.previous({skip_groups = true, jump = true})
  end, {desc = "Prev.trouble"})

  -- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
end

return M
