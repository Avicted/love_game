-- External libraries
-- require "libs/cupid"
Class = require "libs/middleclass"

-- Game libraries
require "libs/helperlib"
require "libs/GState"
require "physics"

local settings = require("settings")

-- Global variables
world = nil
isPlayerAlive = true

function love.resize(w, h)
    -- Store the scaling factor for use in love.draw
    scaleX = w / 640
    scaleY = h / 360
    scale = math.min(scaleX, scaleY)
end

function love.load()
    -- Init Libs
    Init_Graphics()
    GState:load()

    world = love.physics.newWorld(0, 200, true) -- Gravity is being set to 0 in the x direction and 200 in the y direction.
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    -- Initial Game State
    GState:switch("menu_state", false)
end

function love.update(dt)
    world:update(dt)
    GState:update(dt)
end

function love.draw()
    GState:draw()

    -- FPS top left
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 12, 12)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
end
