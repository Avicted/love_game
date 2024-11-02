local state = {}

state.name = "in_game"

local Player = require("classes/player")
local BG1
local BG1Size = 256
local SkyColor = {0 / 255, 205 / 255, 249 / 255}
local GroundImage
local GroundTiles = {}
local GroundTileSize = 16

local bgX = 0
local groundX = 0
local scrollSpeed = 50

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

    -- Update background and ground positions
    bgX = bgX - scrollSpeed * dt
    groundX = groundX - scrollSpeed * dt

    -- Reset positions to create a looping effect
    if bgX <= -BG1Size then
        bgX = 0
        print("bgX reset")
    end

    if groundX <= -GroundTileSize * 3 then
        groundX = 0
    end
end

function state:draw()
    local title = "Press SPACE to fly up"
    love.graphics.setFont(font)

    love.graphics.setBackgroundColor(SkyColor)

    -- Apply scaling to everything inside love.draw
    love.graphics.push() -- Save current transformation state
    love.graphics.scale(scale, scale) -- Apply the scaling transformation

    -- Draw the background
    for i = 0, love.graphics.getWidth() / BG1Size + 1 do
        love.graphics.draw(BG1, bgX + i * BG1Size, 360 - BG1Size - GroundTileSize, 0, 1, 1)
    end

    -- Draw the ground
    for i = 0, love.graphics.getWidth() / GroundTileSize + 1 do
        love.graphics.draw(GroundImage, GroundTiles[i % 3 + 1], groundX + i * GroundTileSize, 360 - GroundTileSize, 0,
            1, 1)
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
