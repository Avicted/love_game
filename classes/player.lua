-- using middleclass.lua create a player class (flappy bird with a sprite)
local Class = require "libs/middleclass"

Player = Class("Player")

function Player:initialize()
    self.x = love.graphics.getWidth() / 4
    self.y = love.graphics.getHeight() / 2
    self.width = 16
    self.height = 16
    self.gravity = -0.00981
    self.lift = 0.05
    self.velocity = 0
    self.image = love.graphics.newImage("resources/sprites/BirdSprite.png")
    self.animationFrames = {love.graphics.newQuad(0, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(16, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(32, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(48, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(64, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(80, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(96, 16, 16, 16, self.image:getDimensions())}
    self.currentFrame = 1
    self.animationSpeed = 0.05
end

function Player:update(dt)
    self.velocity = self.velocity + self.gravity
    self.y = self.y - self.velocity

    -- Animate
    self.currentFrame = self.currentFrame + self.animationSpeed
    if self.currentFrame >= #self.animationFrames then
        self.currentFrame = 1
    end
end

function Player:draw()
    love.graphics.draw(self.image, self.animationFrames[math.floor(self.currentFrame)], self.x, self.y, 0, -1, 1,
        self.width / 2, self.height / 2)
end

function Player:jump()
    self.velocity = self.velocity + self.lift
end

return Player
