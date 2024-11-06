local state = {}

local settings = require("settings")

state.name = "menu_state"

local stars = {} -- Table to hold star positions and sizes
local numStars = 128

function state:load()
    -- Generate star positions and sizes once and store them in the stars table
    for i = 1, numStars do
        local x = math.random(0, settings.width)
        local y = math.random(0, settings.height)
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

    bgMesh = gradientMesh("vertical", {0.0, 0.48, 1.0}, {0.0, 0.84, 1.0}, {0.0, 1.0, 1.0})
    love.graphics.draw(bgMesh, 0, 0, 0, settings.width, settings.height)

    -- Draw stars using stored positions and sizes
    love.graphics.setColor(0.0, 1.0, 1.0) -- Set color to white for stars
    for _, star in ipairs(stars) do
        love.graphics.setPointSize(star.size) -- Set the point size for each star
        love.graphics.points(star.x, star.y) -- Draw the star
    end

    local gameName = "Crow Glide"
    local title = "Main Menu"
    local instruction1 = "Press SPACE to Play"
    local instruction2 = "Press ESC to quit"

    love.graphics.setFont(love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 32))
    local gameName_width = love.graphics.getFont():getWidth(gameName)
    local gameName_y = (settings.height / 2) - 100

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(gameName, (settings.width - gameName_width) / 2, gameName_y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(gameName, (settings.width - gameName_width) / 2 - 4, gameName_y - 1)

    love.graphics.setFont(love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 16))
    local title_width = love.graphics.getFont():getWidth(title)
    local instruction1_width = love.graphics.getFont():getWidth(instruction1)
    local instruction2_width = love.graphics.getFont():getWidth(instruction2)

    local title_y = (settings.height / 2) - 30
    local instruction1_y = (settings.height / 2)
    local instruction2_y = (settings.height / 2) + 30

    -- Press SPACE to Play & Press ESC to quit
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(title, (settings.width - title_width) / 2, title_y)
    love.graphics.print(instruction1, (settings.width - instruction1_width) / 2, instruction1_y)
    love.graphics.print(instruction2, (settings.width - instruction2_width) / 2, instruction2_y)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(title, (settings.width - title_width) / 2 - 2, title_y - 1)
    love.graphics.print(instruction1, (settings.width - instruction1_width) / 2 - 2, instruction1_y - 1)
    love.graphics.print(instruction2, (settings.width - instruction2_width) / 2 - 2, instruction2_y - 1)

    -- bottom center smaller text Created By Avic
    love.graphics.setFont(love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 8))
    local createdBy = "Created By Avic"
    local createdBy_width = love.graphics.getFont():getWidth(createdBy)
    local createdBy_y = settings.height - 16

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(createdBy, (settings.width - createdBy_width) / 2, createdBy_y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(createdBy, (settings.width - createdBy_width) / 2 - 1, createdBy_y - 1)

    love.graphics.pop() -- Restore transformation state
end

function state:unload()

end
return state
