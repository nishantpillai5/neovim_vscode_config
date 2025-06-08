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

local function sanitize_json(json_str)
  local remove_comments = json_str:gsub('//[^\n]*', ''):gsub('/%*.-%*/', '')
  local remove_trailing_commas = remove_comments:gsub(',(%s*[%]}])', '%1')
  return remove_trailing_commas
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

  local clean_content = sanitize_json(content)
  local ok, jsonfile = pcall(vim.fn.json_decode, clean_content)
  if not ok then
    vim.notify('Failed to decode vscode config: ' .. jsonfile, vim.log.levels.ERROR)
    return
  end
  mapVscWhichkeyConfig(jsonfile['whichkey.bindings'], '<leader>')
  mapVscWhichkeyConfig(jsonfile['whichkey.others'], '')
end

local function readNvimKeys()
  local scan = require 'plenary.scandir'
  local Path = require 'plenary.path'
  local modules = {}
  local seen_keys = {}

  local config_dir = vim.fn.stdpath 'config' .. '/lua'
  scan.scan_dir(config_dir, {
    depth = 10,
    on_insert = function(entry)
      if entry:match '%.lua$' then
        local rel_path = Path:new(entry):make_relative(config_dir)
        local mod_name = rel_path:gsub('%.lua$', ''):gsub('/', '.'):gsub('\\', '.')
        table.insert(modules, mod_name)
      end
    end,
  })
  vim.notify('Found ' .. #modules .. ' modules in ' .. config_dir, vim.log.levels.INFO)

  for _, mod in ipairs(modules) do
    local ok, loaded = pcall(require, mod)
    local keymaps = nil
    if ok and type(loaded) == 'table' and loaded.M and loaded.M.keys_all then
      keymaps = loaded.M.keys_all
    elseif ok and type(loaded) == 'table' and loaded.keys_all then
      keymaps = loaded.keys_all
    end
    if keymaps then
      for _, keymap in ipairs(keymaps) do
        if keymap[1] then
          if not keymap.vsc_cmd then
            keymap.vsc_cmd = 'not implemented'
          end
          local mode = keymap.mode or { 'n' }
          local hash = table.concat(keymap.mode) .. keymap[1]
          if seen_keys[hash] then
            vim.notify(
              string.format(
                "Overwriting keymap for '%s' (previous vsc_cmd: %s, new vsc_cmd: %s)",
                keymap[1],
                seen_keys[keymap[1]],
                keymap.vsc_cmd
              ),
              vim.log.levels.WARN
            )
          end
          seen_keys[hash] = keymap.vsc_cmd
          if keymap.vsc_cmd ~= 'not implemented' then
            map_action(mode, keymap[1], keymap.vsc_cmd)
          end
        end
      end
    end
  end

  -- TODO: Export json file
end

-------------------------------------- Set keymaps --------------------------------------------

vscode.action('whichkey.register', { args = { bindings = { 'whichkey', 'others' } } })

-- readVscConfig()

readNvimKeys()

map_action('n', '<leader>', 'whichkey.show')
map_action('n', '<leader><leader>', 'whichkey.show', { args = { 'whichkey.others' } })

-- ctrl+r: "workbench.action.chat.clearHistory"
-- map("n", "<leader>gb", "gitlens.showQuickCommitFileDetails")
