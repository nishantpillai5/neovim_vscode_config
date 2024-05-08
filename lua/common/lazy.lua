local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local M = {}

function M.get_conds(plugins_table)
  local load_plugin = {}
  for _, plugin in ipairs(plugins_table) do
    load_plugin[plugin] = true
  end
  return load_plugin
end

return M
