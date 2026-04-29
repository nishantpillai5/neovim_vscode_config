---@type overseer.ComponentFileDefinition
local comp = {
  desc = 'Inject .vscode/.env into task environment',
  constructor = function()
    return {
      on_pre_start = function(self, task)
        local env = _G.env_reader and _G.env_reader()
        if env then
          task.env = vim.tbl_extend('force', task.env or {}, env)
        end
      end,
    }
  end,
}

return comp