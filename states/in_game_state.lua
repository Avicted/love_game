local state = {}

state.name = "in_game"

local Player = require("classes/player")
local Pipe = require("classes/pipe")
require("physics")

local BG1
local BG1Size = 256
local SkyColor = {0 / 255, 205 / 255, 249 / 255}

local GroundImage
local GroundTiles = {}
local GroundTileSize = 16

local Pipes = {} -- every type of pipe
local PipesInMap = {} -- pipes in use

local bgX = 0
local groundX = 0
local scrollSpeed = 128

local score = 0

function generatePipePair()
    local newX = 200 -- x, should always be minimum last pipe x + 100

    for i, pipe in ipairs(PipesInMap) do
        newX = math.max(newX, pipe.x)
    end

    -- math.randomseed(os.time())

    local pipeX = newX + math.random(100, 600)
    local gapSize = math.random(80, 120) -- Random gap size between pipes

    local upperPipeY = math.random(0, 250 - 80 - gapSize)
    if upperPipeY < 0 then -- Minimum 0
        upperPipeY = 0
    end

    local upperPipe = Pipe(pipeX, upperPipeY, Pipes[1])

    -- Never in the ground or off screen, min y-gap to the top is 80
    local lowerPipeY = upperPipeY + 80 + gapSize
    local lowerPipe = Pipe(pipeX, lowerPipeY, Pipes[1])

    table.insert(PipesInMap, upperPipe)
    table.insert(PipesInMap, lowerPipe)
end

function state:load()
    print("in_game_state loading")

    BG1 = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Background/Background7.png")
    GroundImage = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Tiles/Style 1/TileStyle1.png")

    -- Reset everything
    resetPhysicsWorld()
    isPlayerAlive = true
    groundX = 0
    bgX = 0
    PipesInMap = {}
    score = 0

    -- 4 wide, 2 tall grid of different colored pipes
    -- Only use the first top left for now
    Pipes = {love.graphics.newQuad(0, 0, 32, 80, (32 * 4), (80 * 2))}

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

    if isPlayerAlive then
        if love.keyboard.isDown("space") then
            Player:jump()
        end
    end

    if not isPlayerAlive then
        if love.keyboard.isDown("r") and not self.rPressed then
            self.rPressed = true

            self.load()

        elseif not love.keyboard.isDown("r") then
            self.rPressed = false
        end

        return
    end

    Player:update(dt)

    -- Update background and ground positions
    bgX = bgX - scrollSpeed * dt
    groundX = groundX - scrollSpeed * dt

    -- Update the pipes
    for i, pipe in ipairs(PipesInMap) do
        pipe:update(dt)
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
        if pipe.x < -32 then
            table.remove(PipesInMap, i)

            generatePipePair()
        end
    end

    -- If the player passes through two pipes, increase the score
    for i, pipe in ipairs(PipesInMap) do
        if pipe.x + 32 < Player.body:getX() and not pipe.scored then
            print("Scored!")
            pipe.scored = true
            score = score + 10
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
        love.graphics.draw(BG1, bgX + i * BG1Size, 360 - BG1Size - (-GroundTileSize / 0.2), 0, 1, 1)
    end

    -- Draw the ground
    for i = 0, love.graphics.getWidth() / GroundTileSize + 1 do
        love.graphics.draw(GroundImage, GroundTiles[i % 3 + 1], groundX + i * GroundTileSize, 360 - GroundTileSize, 0,
            1, 1)
    end

    -- Draw the pipes
    for i, pipe in ipairs(PipesInMap) do
        pipe:draw()
    end

    Player:draw()

    if not isPlayerAlive then
        love.graphics.setFont(love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 8))
        love.graphics.setColor(0, 0, 0) -- Set color to white for the title text
        love.graphics.printf("Game Over", 0, 33, 640, "center")
        love.graphics.setColor(1, 1, 1) -- Set color to black for the shadow text
        love.graphics.printf("Game Over", 0, 32, 640, "center")

        love.graphics.setColor(0, 0, 0) -- Set color to white for the title text
        love.graphics.printf("Press R to restart", 0, 65, 640, "center")
        love.graphics.setColor(1, 1, 1) -- Set color to black for the shadow text
        love.graphics.printf("Press R to restart", 0, 64, 640, "center")
    else
        love.graphics.setFont(love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 8))
        love.graphics.setColor(0, 0, 0) -- Set color to white for the title text
        love.graphics.printf(title, 0, 33, 640, "center")
        love.graphics.setColor(1, 1, 1) -- Set color to black for the shadow text
        love.graphics.printf(title, 0, 32, 640, "center")
    end

    -- Score top left
    love.graphics.setFont(love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 16))
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: " .. score, 12, 12)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)

    love.graphics.pop() -- Restore transformation state
end

function state:unload()

end

return state
