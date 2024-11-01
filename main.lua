local settings = require("settings")

local stars = {} -- Table to hold star positions and sizes
local numStars = 128
local scale = 1

function love.load()
    -- Generate star positions and sizes once and store them in the stars table
    for i = 1, numStars do
        local x = math.random(0, 640)
        local y = math.random(0, 360)
        local size = math.random(1, 5) -- Random size between 1 and 5 pixels

        table.insert(stars, {
            x = x,
            y = y,
            size = size -- Store size of each star
        })
    end

    -- Font setup    
    love.graphics.setDefaultFilter("nearest", "nearest") -- Disable smoothing
    font = love.graphics.newFont(128) -- Load the font
    love.graphics.setFont(font)
end

function love.resize(w, h)
    -- Store the scaling factor for use in love.draw
    scaleX = w / 640
    scaleY = h / 360
    scale = math.min(scaleX, scaleY)
end

function love.draw()
    local title = "love_game"
    local font = love.graphics.newFont(32)
    love.graphics.setFont(font)

    love.graphics.setBackgroundColor(0.05, 0.05, 0.2)

    -- Apply scaling to everything inside love.draw
    love.graphics.push() -- Save current transformation state
    love.graphics.scale(scale, scale) -- Apply the scaling transformation

    -- Draw stars using stored positions and sizes
    love.graphics.setColor(1.0, 1.0, 1.0) -- Set color to white for stars
    for _, star in ipairs(stars) do
        love.graphics.setPointSize(star.size) -- Set the point size for each star
        love.graphics.points(star.x, star.y) -- Draw the star
    end

    -- Center the title text
    love.graphics.setColor(1, 1, 1) -- Set color to white for the title text
    love.graphics.printf(title, 0, 180 - font:getHeight() / 2, 640, "center")

    love.graphics.pop() -- Restore transformation state
end
