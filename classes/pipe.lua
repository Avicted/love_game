-- using middleclass.lua create a Pipe class
local Class = require "libs/middleclass"

Pipe = Class("Pipe")

function Pipe:initialize()
    -- Box2D body
    self.body = nil
end

function Pipe:update(dt)

end

function Pipe:draw()

end

return Pipe
