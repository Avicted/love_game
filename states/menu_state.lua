local state = {}

state.name = "menu_state"

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

    self.font = love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 24)
    love.graphics.setFont(self.font)
end

function state:update(dt)
    if love.keyboard.isDown("space") then
        GState:switch("in_game_state", true)
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

function state:draw()
    -- Apply scaling to everything inside love.draw
    love.graphics.push() -- Save current transformation state
    love.graphics.scale(scale, scale) -- Apply the scaling transformation

    bgMesh = gradientMesh("vertical", {0.0, 0.48, 1.0}, {0.0, 0.84, 1.0})
    love.graphics.draw(bgMesh, 0, 0, 0, love.graphics.getDimensions())

    -- Draw stars using stored positions and sizes
    love.graphics.setColor(0.0, 1.0, 1.0) -- Set color to white for stars
    for _, star in ipairs(stars) do
        love.graphics.setPointSize(star.size) -- Set the point size for each star
        love.graphics.points(star.x, star.y) -- Draw the star
    end

    love.graphics.pop() -- Restore transformation state

    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()
    local title = "Main Menu"
    local instruction1 = "Press SPACE to Play"
    local instruction2 = "Press ESC to quit"

    local title_width = love.graphics.getFont():getWidth(title)
    local instruction1_width = love.graphics.getFont():getWidth(instruction1)
    local instruction2_width = love.graphics.getFont():getWidth(instruction2)

    local title_y = (window_height / 2) - 60
    local instruction1_y = (window_height / 2)
    local instruction2_y = (window_height / 2) + 60

    love.graphics.setFont(self.font)
    love.graphics.setColor(0, 0, 0) -- Set color to black for the title text
    love.graphics.print(title, (window_width - title_width) / 2, title_y)
    love.graphics.print(instruction1, (window_width - instruction1_width) / 2, instruction1_y)
    love.graphics.print(instruction2, (window_width - instruction2_width) / 2, instruction2_y)

    love.graphics.setColor(1, 1, 1) -- Set color to white for the shadow text
    love.graphics.print(title, (window_width - title_width) / 2 - 1, title_y - 1)
    love.graphics.print(instruction1, (window_width - instruction1_width) / 2 - 1, instruction1_y - 1)
    love.graphics.print(instruction2, (window_width - instruction2_width) / 2 - 1, instruction2_y - 1)

end

function state:unload()

end
return state
