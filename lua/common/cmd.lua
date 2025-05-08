vim.api.nvim_create_user_command('ClearShada', function()
  if require('common.env').OS == 'windows' then
    local shadapath = vim.fn.stdpath 'data' .. '\\shada'
    vim.notify('del /s /q ' .. shadapath .. '\\*')
    vim.fn.system('del /s /q ' .. shadapath .. '\\*')
  else
    local shadapath = vim.fn.stdpath 'data' .. '/shada'
    vim.notify('rm -rf ' .. shadapath .. '/*')
    vim.fn.system('rm -rf ' .. shadapath .. '/*')
  end
end, {})
