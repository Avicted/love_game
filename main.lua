-- External libraries
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

-- Define fixed 16:9 resolution
local fixedWidth = 640
local fixedHeight = 360

local scaleX, scaleY, scale, offsetX, offsetY

function love.resize(w, h)
    -- Calculate scale to fit the 16:9 resolution
    scaleX = w / fixedWidth
    scaleY = h / fixedHeight
    scale = math.min(scaleX, scaleY)

    -- Calculate offsets to center the game content in the window
    offsetX = (w - fixedWidth * scale) / 2
    offsetY = (h - fixedHeight * scale) / 2

    -- Update any chain effects if needed
    chain.resize(w, h)
end

function love.load()
    -- Init Libs
    Init_Graphics()
    GState:load()

    -- Initialize moonshine effects
    chain = moonshine(fixedWidth, fixedHeight, moonshine.effects.crt).chain(moonshine.effects.vignette).chain(
        moonshine.effects.scanlines)
    chain.vignette.radius = 1.4
    chain.vignette.opacity = 0.4
    chain.scanlines.opacity = 0.04
    chain.crt.distortionFactor = {1.02, 1.02}

    -- Init Physics
    resetPhysicsWorld()

    -- Calculate scale and offsets for initial window size
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    scaleX = w / fixedWidth
    scaleY = h / fixedHeight
    scale = math.min(scaleX, scaleY)
    offsetX = (w - fixedWidth * scale) / 2
    offsetY = (h - fixedHeight * scale) / 2

    -- Initial Game State
    GState:switch("menu_state", false)
end

function love.update(dt)
    world:update(dt)
    GState:update(dt)
end

function love.draw()
    -- Apply the shader effect chain
    chain(function()
        -- Set scissor to restrict drawing area to 640x360 centered in the window
        love.graphics.setScissor(offsetX, offsetY, fixedWidth * scale, fixedHeight * scale)

        -- Apply offset to ensure the game content stays centered
        love.graphics.push()
        love.graphics.translate(offsetX, offsetY)
        love.graphics.scale(scale)

        -- Draw the game state (this is where your actual game content is drawn)
        GState:draw()

        -- FPS bottom left (with black shadow for readability)
        love.graphics.setFont(love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 8))
        local fps_y = settings.height
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 16, fps_y - 16)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 16, fps_y - 17)

        -- Pop the transformation matrix to return to normal state
        love.graphics.pop()

        -- Clear the scissor restriction
        love.graphics.setScissor()
    end)
end
