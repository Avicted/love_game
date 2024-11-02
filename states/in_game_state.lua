local state = {}

state.name = "in_game"

local stars = {} -- Table to hold star positions and sizes
local numStars = 128

function state:load()
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
end

function state:update(dt)
    if love.keyboard.isDown("backspace") then
        GState:switch("menu_state", true)
    end
end

function state:draw()
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

function state:unload()

end
return state
