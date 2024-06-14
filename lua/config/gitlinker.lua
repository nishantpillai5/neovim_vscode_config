local M = {}

M.setup = function()
  require('gitlinker').setup {
    router = {
      browse = {
        ['^dev%.azure%.com'] = 'https://dev.azure.com/'
          .. '{_A.ORG}/'
          .. '{_A.REPO}/blob/'
          .. '{_A.REV}/'
          .. '{_A.FILE}?plain=1' -- '?plain=1'
          .. '#L{_A.LSTART}'
          .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
      },
    },
  }
end

M.config = function()
  M.setup()
end

-- M.config()

return M
