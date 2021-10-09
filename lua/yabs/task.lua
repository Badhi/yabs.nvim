local Task = {
    scopes = {
        GLOBAL = 1,
        LOCAL = 2,
        ALL = 3
    }
}

function Task:new(args)
    local state = {
        name = args.name,
        command = args.command,
        type = args.type,
        output = args.output,
        opts = args.opts or {}
    }

    self.__index = self
    return setmetatable(state, self)
end

function Task:setup(parent)
    -- if not self.output then self.output = parent.output end
    -- if not self.type then self.type = parent.type end
    assert(self.output, "yabs: error: output for task " .. self.name .. " is nil")
    assert(self.type, "yabs: error: type for task " .. self.name .. " is nil")

    parent.tasks[self.name] = self
end

function Task:run(opts)
    local command
    if type(self.command) == "function" then
        -- If `self.command` is a function, command is its return value
        command = self.command()
        if self.type == "lua" then return end
    else
        command = self.command
    end

    command = require("yabs.util").expand(command)

    if self.type == "vim" then
        vim.cmd(command)
    elseif self.type == "shell" then
        -- output(command, self.opts)
        opts = opts or {}
        opts = vim.tbl_extend("force", self.opts, opts)
        require("yabs.util").run_command(command, self.output, opts)
    end
end

return Task
