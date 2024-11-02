local scale = 1

function Init_Graphics()
    love.graphics.setDefaultFilter("nearest", "nearest") -- Disable smoothing
    font = love.graphics.newFont(32) -- Load the font
    love.graphics.setFont(font)
end

