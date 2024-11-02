-- require "libs/cupid"
Class = require "libs/middleclass"
require "libs/GState"

local settings = require("settings")

function love.resize(w, h)
    -- Store the scaling factor for use in love.draw
    scaleX = w / 640
    scaleY = h / 360
    scale = math.min(scaleX, scaleY)
end

local scale = 1

function love.load()
    -- Font setup    
    love.graphics.setDefaultFilter("nearest", "nearest") -- Disable smoothing
    font = love.graphics.newFont(32) -- Load the font
    love.graphics.setFont(font)

    -- Init Libs
    GState:load()

    GState:switch("menu_state", false)
end

function love.update(dt)
    GState:update(dt)
end

function love.draw()
    GState:draw()
end
