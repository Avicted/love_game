-- using middleclass.lua create a Pipe class
local Class = require "libs/middleclass"

-- World is a global variable that is defined in main.lua
-- It is used to create the Box2D body for the pipe
require "physics"

Pipe = Class("Pipe")

local PiplesImage
local pipeWidth = 32
local pipeHeight = 80
local scrollSpeed = 64

function Pipe:initialize(x, y, quad)
    PiplesImage = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Tiles/Style 1/PipeStyle1.png")

    -- Which pipe to use in the pipe sprite sheet (PipeImage)
    self.quad = quad

    self.x = x
    self.y = y

    -- Box2D body
    self.body = love.physics.newBody(world, pipeWidth, pipeHeight, "static")
    self.shape = love.physics.newRectangleShape(pipeWidth, pipeHeight)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("Pipe")

    -- Set the body position to the pipe position
    self.body:setX(self.x)
    self.body:setY(self.y)
end

function Pipe:update(dt)
    self.body:setX(self.body:getX() - scrollSpeed * dt)
end

function Pipe:draw()
    love.graphics.draw(PiplesImage, self.quad, self.body:getX(), self.body:getY(), 0, 1, 1, pipeWidth / 2,
        pipeHeight / 2)

    -- Draw the Box2D body for debugging
    love.graphics.setColor(1, 0, 1)
    love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1, 1, 1)
end

return Pipe
