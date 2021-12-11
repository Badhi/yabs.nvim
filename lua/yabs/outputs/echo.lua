local utils = require('yabs.utils')
local Job = require('plenary.job')

local function echo(_, data)
  print(vim.fn.system(data))
end

local function echo_async(cmd, opts)
  opts = opts or {}

  local splitted_cmd = utils.split_cmd(cmd)
  local job = Job:new({
    command = table.remove(splitted_cmd, 1),
    args = splitted_cmd,
    on_stdout = vim.schedule_wrap(echo),
    on_stderr = vim.schedule_wrap(echo),
    on_exit = vim.schedule_wrap(opts.on_exit),
  })
  job:start()
end

local Output = require('yabs.output')
return Output:new(echo_async)
