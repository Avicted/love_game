-- using middleclass.lua create a player class (flappy bird with a sprite)
local Class = require "libs/middleclass"

Player = Class("Player")

function Player:initialize()
    self.x = 640 / 4
    self.y = 360 / 2

    self.gravity = -0.00981
    self.lift = 0.10
    self.velocity = 0

    self.width = 16
    self.height = 16
    self.image = love.graphics.newImage("resources/sprites/BirdSprite.png")
    self.animationFrames = {love.graphics.newQuad(0, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(16, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(32, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(48, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(64, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(80, 16, 16, 16, self.image:getDimensions()),
                            love.graphics.newQuad(96, 16, 16, 16, self.image:getDimensions())}
    self.currentFrame = 1
    self.animationSpeed = 0.10

    -- Box2D body
    self.body = love.physics.newBody(world, 8, 8, "dynamic")
    self.shape = love.physics.newRectangleShape(8, 8)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("Player")

    -- Set the body position to the player position
    self.body:setX(self.x)
    self.body:setY(self.y)

    self.body:setFixedRotation(true)
    self.body:setLinearDamping(0.1)
    self.body:setLinearVelocity(0, 0)
end

function Player:update(dt)
    self.body:setY(self.body:getY() - self.velocity)

    -- If the player is below the screen height, reset the game
    if self.body:getY() > (360 - 16) then
        isPlayerAlive = false
    end

    -- Limit the players top most position top the screen height - 16
    if self.body:getY() < 7 then
        self.body:setY(7)
    end

    -- Animate
    self.currentFrame = self.currentFrame + self.animationSpeed
    if self.currentFrame >= #self.animationFrames then
        self.currentFrame = 1
    end
end

function Player:draw()
    love.graphics.draw(self.image, self.animationFrames[math.floor(self.currentFrame)], self.body:getX(),
        self.body:getY(), 0, -1, 1, self.width / 2, self.height / 2)

    -- Draw the Box2D body for debugging
    -- love.graphics.setColor(1, 0, 0)
    -- love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
    -- love.graphics.setColor(1, 1, 1)
end

function Player:jump()
    self.body:applyLinearImpulse(0, -0.75)
end

return Player
