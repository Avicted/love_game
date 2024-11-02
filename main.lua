-- External libraries
-- require "libs/cupid"
Class = require "libs/middleclass"

-- Game libraries
require "libs/helperlib"
require "libs/GState"

local settings = require("settings")

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

    GState:switch("menu_state", false)
end

function love.update(dt)
    GState:update(dt)
end

function love.draw()
    GState:draw()
end
