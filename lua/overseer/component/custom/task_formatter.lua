return {
  desc = 'display formatted task name',
  editable = false,
  serializable = true,
  constructor = function(params)
    return {
      render = function(self, task, lines, highlights, detail)
        -- TODO: display time started, time ended, and duration
        table.insert(lines, _G.task_formatter(task))
        table.insert(highlights, { '@text.underline', #lines, 0, -1 })
      end,
    }
  end,
}
