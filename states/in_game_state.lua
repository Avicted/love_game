local state = {}

state.name = "in_game"

local settings = require("settings")

local Player = require("classes/player")
local Pipe = require("classes/pipe")
require("physics")

local font8
local font16

local BG1
local BG1Size = 256
local BG2Size = 256
local SkyColor = {0 / 255, 205 / 255, 249 / 255}
local SkyImage
local BG2

local GroundImage
local GroundTiles = {}
local GroundTileSize = 16

local Pipes = {} -- every type of pipe
local PipesInMap = {} -- pipes in use

local bgX = 0
local bgX2 = 0
local groundX = 0
local scrollSpeed = 128

local score = 0
local totalPipesRemoved = 0

function generatePipePair()
    local newX = 200 -- x, should always be minimum last pipe x + 100

    for i, pipe in ipairs(PipesInMap) do
        newX = math.max(newX, pipe.x)
    end

    math.randomseed(os.time())

    local pipeX = newX + math.random(100, 600)
    local baseGapSize = 120 -- Base gap size between pipes
    local gapReduction = math.min(score / 10, 40) -- Reduce gap size based on score, max reduction of 40
    local gapSize = math.random(baseGapSize - gapReduction, baseGapSize - gapReduction + 40)

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

    -- print("Pipe pair generated")
end

function state:load()
    print("in_game_state loading")

    BG1 = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Background/Background7.png")
    GroundImage = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Tiles/Style 1/TileStyle1.png")
    SkyImage = love.graphics.newImage("resources/sprites/sky.png")
    BG2 = love.graphics.newImage("resources/sprites/Flappy Bird Assets/Background/Background2.png")

    font8 = love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 8)
    font16 = love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 16)

    -- Set random seed
    math.randomseed(os.time())

    -- Reset everything
    resetPhysicsWorld()
    isPlayerAlive = true
    groundX = 0
    bgX = 0
    bgX2 = 0
    PipesInMap = {}
    score = 0
    scrollSpeed = 128

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

    -- Input handling
    if isPlayerAlive then
        if love.keyboard.isDown("space") then
            Player:jump()

            Player.animationSpeed = math.min(Player.animationSpeed * 1.5, 0.80)
        else
            Player.animationSpeed = baseAnimationSpeed
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
    bgX2 = bgX2 - scrollSpeed * 0.4 * dt
    groundX = groundX - scrollSpeed * dt

    -- Update the pipes
    for i, pipe in ipairs(PipesInMap) do
        pipe:update(dt)
    end

    -- Reset positions to create a looping effect
    if bgX <= -BG1Size then
        bgX = bgX + BG1Size
        -- print("bgX reset")
    end
    if bgX2 <= -BG2Size then
        bgX2 = bgX2 + BG2Size
        -- print("bgX2 reset")
    end

    if groundX <= -GroundTileSize * 3 then
        groundX = groundX + GroundTileSize * 3
    end

    -- Reset pipes that are off screen
    for i = #PipesInMap, 1, -1 do
        local pipe = PipesInMap[i]
        if pipe.x < -32 then
            table.remove(PipesInMap, i)
            totalPipesRemoved = totalPipesRemoved + 1

            if totalPipesRemoved % 2 == 0 then
                generatePipePair()
            end
        end
    end

    -- If the player passes through two pipes, increase the score
    for i, pipe in ipairs(PipesInMap) do
        if pipe.x + 32 < Player.body:getX() and not pipe.scored then
            print("Scored!")
            pipe.scored = true
            score = score + 16

            if score % 128 == 0 then
                scrollSpeed = scrollSpeed + 16

                for i, pipe in ipairs(PipesInMap) do
                    pipe.scrollSpeed = scrollSpeed
                end

                print("Scroll speed increased to " .. scrollSpeed)
            end
        end
    end

end

function state:draw()
    local title = "Press SPACE to fly up"

    love.graphics.setBackgroundColor(0, 0, 0)

    -- Apply scaling to everything inside love.draw
    love.graphics.push() -- Save current transformation state
    love.graphics.scale(scale, scale) -- Apply the scaling transformation

    -- Draw the Sky
    love.graphics.draw(SkyImage, 0, 0, 0, 1, 1)

    -- Draw a parallax effect with the background, smaller scale higher up
    for i = 0, settings.width / BG2Size + 4 do
        love.graphics.draw(BG2, bgX2 + i * (BG2Size * 0.50), settings.height - 260, 0, 0.50, 0.50) -- Scale 0.50 for the background
        love.graphics.setColor(SkyColor[1], SkyColor[2], SkyColor[3], 0.50) -- Sky colored Fog 0.50 transparency
        love.graphics.rectangle("fill", bgX2 + i * (BG2Size * 0.5), settings.height - 260, BG2Size, 220)
        love.graphics.setColor(1, 1, 1)
    end

    -- Draw the background
    for i = 0, settings.width / BG1Size + 1 do
        love.graphics.draw(BG1, bgX + i * BG1Size, settings.height - BG1Size - (-GroundTileSize / 0.2), 0, 1, 1)
    end

    -- Draw the ground
    for i = 0, settings.width / GroundTileSize + 1 do
        love.graphics.draw(GroundImage, GroundTiles[i % 3 + 1], groundX + i * GroundTileSize,
            settings.height - GroundTileSize, 0, 1, 1)
    end

    -- Draw the pipes
    for i, pipe in ipairs(PipesInMap) do
        if pipe.x > -32 and pipe.x < settings.width + 32 then
            pipe:draw()
        end
    end

    Player:draw()

    if not isPlayerAlive then
        love.graphics.setFont(font8)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Game Over", 0, 33, settings.width, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Game Over", 0, 32, settings.width, "center")

        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Press R to restart", 0, 65, settings.width, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press R to restart", 0, 64, settings.width, "center")
    else
        love.graphics.setFont(font8)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Press BACKSPACE to go back to the menu", 68, 17, settings.width, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press BACKSPACE to go back to the menu", 67, 16, settings.width, "center")

        love.graphics.setFont(font8)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(title, 0, 33, settings.width, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(title, 0, 32, settings.width, "center")
    end

    -- Score top left
    love.graphics.setFont(font16)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: " .. score, 12, 12)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)

    love.graphics.pop() -- Restore transformation state
end

function state:unload()

end

return state
