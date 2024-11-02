GState = {}

function GState:load()
    self.stack = {}
    self.previousState = nil
end

function GState:update(dt)
    for i, v in ipairs(self.stack) do
        v.stateData:update(dt)
    end

    if #self.stack < 1 then
        GState:push("in_game_state")
    end
end

function GState:draw()
    for i, v in ipairs(self.stack) do
        v.stateData:draw()
    end
end
--

function GState:push(state)
    local newState = require("states/" .. state)
    print("Pushing: " .. newState.name .. " onto stack!")
    table.insert(self.stack, {
        fileName = state,
        stateData = newState
    })
    self.stack[#self.stack].stateData:load()
end

function GState:popLast()
    if self.stack[#self.stack - 1] ~= nil then
        print("Removing: " .. tostring(self.stack[#self.stack].name) .. " from stack!")
        self.stack[#self.stack - 1].stateData:unload()
        table.remove(self.stack, #self.stack - 1)
    end
end

function GState:popCurrent()
    if self.stack[#self.stack] ~= nil then
        print("Removing: " .. tostring(self.stack[#self.stack].name) .. " from stack!")
        self.stack[#self.stack].stateData:unload()
        table.remove(self.stack, #self.stack)
    end
end

function GState:switch(state, unloadfirst)
    if unloadfirst then
        collectgarbage()
        self:popCurrent()
    end

    self:push(state)
    self.stack[#self.stack].stateData:load()

    if self.stack[#self.stack - 1] ~= nil then
        self.previousState = self.stack[#self.stack - 1].fileName
    end

    if not unloadfirst then
        self:popLast()
        collectgarbage()
    end
end

function GState:printStackInfo()
    print("Current stack size: " .. #self.stack)

    for i = 1, #self.stack do
        print("#" .. i .. " " .. self.stack[i].stateData.name)
    end
end

function GState:getActiveStates()
    return self.stack
end

function GState:getCurrentState()
    return self.stack[#self.stack]
end
