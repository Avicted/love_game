local state = {}

state.name = "in_game"

local Player = require("classes/player")
local BG1
local BG1Size = 256
local SkyColor = {0 / 255, 205 / 255, 249 / 255}

local GroundImage
local GroundTiles = {}
local GroundTileSize = 16

local pipeWidth = 32
local pipeHeight = 80
local PiplesImage
local Pipes = {} -- every type of pipe
local PipesInMap = {} -- pipes in use

local bgX = 0
local groundX = 0
local scrollSpeed = 64

function generatePipePair()
    -- x, should always be minimum last pipe x + 100
    local newX = 0

    for i, pipe in ipairs(PipesInMap) do
        newX = math.max(newX, pipe.x)
    end

    local pipeX = newX + math.random(100, 600)
    local gapSize = math.random(80, 120) -- Random gap size between pipes

    local upperPipeY = math.random(0, 250 - pipeHeight - gapSize)
    local upperPipe = {
        x = pipeX,
        y = upperPipeY
    }

    -- Never in the ground or off screen, min y-gap to the top is 80
    local lowerPipeY = upperPipeY + pipeHeight + gapSize
    local lowerPipe = {
        x = pipeX,
        y = lowerPipeY
    }

    table.insert(PipesInMap, upperPipe)
    table.insert(PipesInMap, lowerPipe)
end

function state:load()
    BG1 = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Background/Background7.png")
    GroundImage = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Tiles/Style 1/TileStyle1.png")
    PiplesImage = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Tiles/Style 1/PipeStyle1.png")

    -- 4 wide, 2 tall grid of different colored pipes
    -- Only use the first top left for now
    Pipes = {love.graphics.newQuad(0, 0, pipeWidth, pipeHeight, PiplesImage:getDimensions())}

    -- Start with PipesInMap empty 10 pairs of pipes the upper and lower part, the upper is flipped
    for i = 1, 10 do
        generatePipePair()
    end

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

    -- Update the pipes
    for i, pipe in ipairs(PipesInMap) do
        pipe.x = pipe.x - scrollSpeed * dt
    end

    -- Reset positions to create a looping effect
    if bgX <= -BG1Size then
        bgX = 0
        print("bgX reset")
    end

    if groundX <= -GroundTileSize * 3 then
        groundX = 0
    end

    -- Reset pipes that are off screen
    for i, pipe in ipairs(PipesInMap) do
        if pipe.x < -pipeWidth then
            table.remove(PipesInMap, i)

            generatePipePair()
        end
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

    -- Draw the pipes
    for i, pipe in ipairs(PipesInMap) do
        love.graphics.draw(PiplesImage, Pipes[1], pipe.x, pipe.y, 0, 1, 1)
    end

    love.graphics.setColor(0, 0, 0) -- Set color to white for the title text
    love.graphics.printf(title, 0, 32, 640, "center")
    love.graphics.setColor(1, 1, 1) -- Set color to black for the shadow text
    love.graphics.printf(title, 0, 34, 640, "center")

    love.graphics.pop() -- Restore transformation state
end

function state:unload()

end

return state
