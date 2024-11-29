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
      end,
      on_start = function(self)
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
      end,
    }
  end,
}

return comp
