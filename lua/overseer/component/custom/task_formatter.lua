local task_list = require 'overseer.task_list'
local util = require 'overseer.util'

local timer

---@type overseer.ComponentFileDefinition
local comp = {
  desc = 'display formatted task',
  params = {
    detail_level = {
      desc = 'Show the formatted task at this detail level',
      type = 'integer',
      default = 1,
      validate = function(v)
        return v >= 1 and v <= 3
      end,
    },
  },
  constructor = function(params)
    return {
      duration = nil,
      start_time = nil,
      on_reset = function(self, task)
        self.duration = nil
        self.start_time = nil
        self.end_time = nil
        local beepboop_status, _ = pcall(require, 'beepboop')
        if beepboop_status and self.audio_handle then
          require('beepboop').stop_audio(self.audio_handle)
        end
        self.audio_handle = nil
      end,
      ---@return nil|boolean
      on_pre_start = function(self, task)
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if
            vim.api.nvim_get_option_value('modifiable', { buf = buf })
            and vim.api.nvim_get_option_value('modified', { buf = buf })
          then
            vim.notify('Running task with unsaved changes', 'warn')
            break
          end
        end
      end,
      on_start = function(self, task)
        local beepboop_status, _ = pcall(require, 'beepboop')
        if beepboop_status and require('config.overseer').filter_build_tasks(task) then
          self.audio_handle = require('beepboop').play_audio("elevator")
        end
        if not timer then
          timer = assert(vim.loop.new_timer())
          timer:start(
            1000,
            1000,
            vim.schedule_wrap(function()
              task_list.rerender()
            end)
          )
        end
        self.start_time = os.time()
      end,
      on_complete = function(self)
        local beepboop_status, _ = pcall(require, 'beepboop')
        if beepboop_status and self.audio_handle then
          require('beepboop').stop_audio(self.audio_handle)
        end
        self.duration = os.time() - self.start_time
        self.end_time = os.time()
      end,
      render = function(self, task, lines, highlights, detail)
        if detail < params.detail_level then
          return
        end

        table.insert(lines, _G.task_formatter(task))
        table.insert(highlights, { '@text.underline', #lines, 0, -1 })

        local duration = self.duration or os.time() - (self.start_time or os.time())
        local start_time = os.date('%X', self.start_time) or ''
        local end_time = os.date('%X', self.end_time) or ''
        table.insert(lines, util.format_duration(duration) .. ' (' .. start_time .. ' - ' .. end_time .. ')')
        table.insert(highlights, { '@label', #lines, 0, -1 })
      end,
    }
  end,
}

return comp
