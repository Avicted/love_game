local state = {}

state.name = "in_game"

local Player = require("classes/player")
local BG1
local BG1Size = 256
local SkyColor = {0 / 255, 205 / 255, 249 / 255}
local GroundImage
local GroundTiles = {}
local GroundTileSize = 16

function state:load()
    BG1 = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Background/Background7.png")
    GroundImage = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Tiles/Style 1/TileStyle1.png")

    -- The ground tiles are bottom left, 3 frames of 16x16 pixels
    GroundTiles = {love.graphics.newQuad((0 * GroundTileSize) + 16, 80, GroundTileSize, GroundTileSize,
        GroundImage:getDimensions()),
                   love.graphics
        .newQuad((1 * GroundTileSize) + 16, 80, GroundTileSize, GroundTileSize, GroundImage:getDimensions()),
                   love.graphics
        .newQuad((2 * GroundTileSize) + 16, 80, GroundTileSize, GroundTileSize, GroundImage:getDimensions())}

    Player:initialize()
end

function state:update(dt)
    if love.keyboard.isDown("backspace") then
        GState:switch("menu_state", true)
    end

    if love.keyboard.isDown("space") then
        Player:jump()
    end

    Player:update(dt)
end

function state:draw()
    local title = "Press SPACE to fly up"
    love.graphics.setFont(font)

    love.graphics.setBackgroundColor(SkyColor)

    -- Apply scaling to everything inside love.draw
    love.graphics.push() -- Save current transformation state
    love.graphics.scale(scale, scale) -- Apply the scaling transformation

    -- Draw the ground GroundTiles
    for i = 0, 650 / GroundTileSize do
        love.graphics.draw(GroundImage, GroundTiles[i % 2 + 1], i * GroundTileSize, 360 - GroundTileSize, 0, 1, 1)
    end

    for i = 0, love.graphics.getWidth() / BG1Size do
        love.graphics.draw(BG1, i * BG1Size, 360 - BG1Size - GroundTileSize, 0, 1, 1)
    end

    Player:draw()

    love.graphics.setColor(0, 0, 0) -- Set color to white for the title text
    love.graphics.printf(title, 0, 32, 640, "center")
    love.graphics.setColor(1, 1, 1) -- Set color to black for the shadow text
    love.graphics.printf(title, 0, 34, 640, "center")

    love.graphics.pop() -- Restore transformation state

end

function state:unload()

end

return state
