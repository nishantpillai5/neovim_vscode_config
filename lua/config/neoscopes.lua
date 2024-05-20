local M = {}

local global_scopes = function()
  local neoscopes = require("neoscopes")
  neoscopes.add({ name = "notes", dirs = { require('common.env').DIR_NOTES } })
  neoscopes.add({ name = "nvim_config", dirs = { require('common.env').DIR_NVIM } })
end

local replace_telescope_keymaps = function()
  local neoscopes = require("neoscopes")
  vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files({
      prompt_prefix = "󱇳 > ",
      search_dirs = neoscopes.get_current_dirs(),
    })
  end, { desc = "Find.files(workspace)" })
  -- remapping fa, f/, fgg not needed

  vim.keymap.set("n", "<leader>fl", function()
    require("telescope.builtin").live_grep({
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { "--follow" },
    })
  end, { desc = "Find.Live_grep.global(workspace)" })

  vim.keymap.set("n", "<leader>f?", function()
    require("telescope.builtin").grep_string({
      prompt_prefix = "󱇳 > ",
      search = vim.fn.input("Search > "),
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { "--follow" },
    })
  end, { desc = "Find.Search.global(workspace)" })

  vim.keymap.set("n", "<leader>fw", function()
    local word = vim.fn.expand("<cword>")
    require("telescope.builtin").grep_string({
      search = word,
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { "--follow" },
    })
  end, { desc = "Find.word(workspace)" })

  vim.keymap.set("n", "<leader>fW", function()
    local word = vim.fn.expand("<cWORD>")
    require("telescope.builtin").grep_string({
      search = word,
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { "--follow" },
    })
  end, { desc = "Find.whole_word(workspace)" })
end

local refresh_workspace = function()
  local neoscopes = require("neoscopes")
  local current_scope = neoscopes.get_current_scope()
  if current_scope == nil then
    vim.notify("󱇳 No scope selected")
    require("config.telescope").keymaps()
  else
    vim.notify("Scope selected: 󱇳 " .. neoscopes.get_current_scope().name)
    replace_telescope_keymaps()
  end
end

M.keymaps = function ()
  local neoscopes = require("neoscopes")
  vim.keymap.set("n", "<leader>ww", function()
    neoscopes.setup({ on_scope_selected = refresh_workspace })
    global_scopes()
    neoscopes.select()
  end)

  vim.keymap.set("n", "<leader>wx", function()
    neoscopes.clear()
    refresh_workspace()
  end)
end

local function lualine_status()
  local neoscopes = require("neoscopes")
  local current_scope = neoscopes.get_current_scope()
  if current_scope == nil then
    return "󱇳 "
  end
  return "󱇳 " .. neoscopes.get_current_scope().name
end

M.lualine = function ()
  local lualineZ = require("lualine").get_config().tabline.lualine_z or {}
  table.insert(lualineZ, { lualine_status })

  require("lualine").setup({
    tabline = { lualine_z = lualineZ },
  })

end

return M
