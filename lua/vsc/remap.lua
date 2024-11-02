local vscode = require 'vscode'

-------------------------------------- Helpers ------------------------------------------

local function map_action(mode, key, input, opts)
  -- Asynchronous keymaps
  vim.keymap.set(mode, key, function()
    vscode.action(input, opts)
  end, { noremap = true, silent = true })
end

local function map_node(mode, binding)
  if string.find(binding, '<leader>') then
    local node = string.gsub(binding, '<leader>', '')
    vim.keymap.set(mode, binding, function()
      vscode.call 'whichkey.show'
      vscode.call('whichkey.triggerKey', { args = { node } })
    end, { noremap = true, silent = true })
  else
    -- FIXME: messes up g bindings
    -- local node = binding
    -- vim.keymap.set(mode, binding, function()
    --   vscode.call('whichkey.show', { args = { 'whichkey.others' } })
    --   vscode.call('whichkey.triggerKey', { args = { node } })
    -- end, { noremap = true, silent = true })
  end
end

local function mapVscWhichkeyConfig(json, binding)
  binding = binding or ''
  if type(json) == 'table' then
    if #json > 0 then
      for _, value in ipairs(json) do
        mapVscWhichkeyConfig(value, binding)
      end
    else
      if not json['key'] then
        vim.notify('Key is nil: ' .. binding)
      end
      binding = binding .. json['key']
      if json['type'] == 'bindings' then
        map_node({ 'n', 'v' }, binding)
        mapVscWhichkeyConfig(json['bindings'], binding)
      elseif json['type'] == 'command' then
        local opts = nil
        if json['args'] then
          if type(json['args']) == 'table' then
            opts = { args = json['args'] }
          else
            opts = { args = { json['args'] } }
          end
        end
        map_action({ 'n', 'v' }, binding, json['command'], opts)
      end
    end
  end
end

local function readVscConfig()
  local path = require('common.env').VSC_CONFIG
  local file = io.open(path, 'r')
  if not file then
    vim.notify('Failed to read vscode config: ' .. path, vim.log.levels.ERROR)
    return
  end
  local content = file:read '*a'
  file:close()
  local ok, jsonfile = pcall(vim.fn.json_decode, content)
  if not ok then
    vim.notify('Failed to decode vscode config: ' .. jsonfile, vim.log.levels.ERROR)
    return
  end
  mapVscWhichkeyConfig(jsonfile['whichkey.bindings'], '<leader>')
  mapVscWhichkeyConfig(jsonfile['whichkey.others'], '')
end

-------------------------------------- Set keymaps --------------------------------------------

vscode.action('whichkey.register', { args = { bindings = { 'whichkey', 'others' } } })

readVscConfig()

map_action('n', '<leader>', 'whichkey.show')
map_action('n', '<leader><leader>', 'whichkey.show', { args = { 'whichkey.others' } })

-- ctrl+r: "workbench.action.chat.clearHistory"
-- map("n", "<leader>gb", "gitlens.showQuickCommitFileDetails")
