local scale = 1

function Init_Graphics()
    love.graphics.setDefaultFilter("nearest", "nearest") -- Disable smoothing

    font = love.graphics.newFont("resources/fonts/SuperMarioBros2.ttf", 32)
    love.graphics.setFont(font)
end

