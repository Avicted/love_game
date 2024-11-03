-- External libraries
-- require "libs/cupid"
local moonshine = require "libs/moonshine"

Class = require "libs/middleclass"

-- Game libraries
require "libs/helperlib"
require "libs/GState"
require "physics"

local settings = require("settings")

-- Global variables
world = nil
isPlayerAlive = true
chain = {}

function love.resize(w, h)
    -- Store the scaling factor for use in love.draw
    scaleX = w / settings.width
    scaleY = h / settings.height
    scale = math.min(scaleX, scaleY)

    chain.resize(w, h)
end

function love.load()
    -- Init Libs
    Init_Graphics()
    GState:load()

    chain = moonshine(settings.width, settings.height, moonshine.effects.crt).chain(moonshine.effects.vignette).chain(
        moonshine.effects.scanlines)
    chain.vignette.radius = 1.4
    chain.vignette.opacity = 0.4
    chain.scanlines.opacity = 0.08
    chain.crt.distortionFactor = {1.02, 1.02}

    -- Init Physics
    resetPhysicsWorld()

    -- Initial Game State
    GState:switch("menu_state", false)
end

function love.update(dt)
    world:update(dt)
    GState:update(dt)
end

function love.draw()
    chain(function()
        GState:draw()

        -- FPS bottom left
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 16, love.graphics.getHeight() - 40)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 16, love.graphics.getHeight() - 41)
    end)
end
