local state = {}

state.name = "menu_state"

function state:load()

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
    local window_width = love.graphics.getWidth()
    local title = "Menu State"
    local instruction1 = "Press SPACE to switch to in_game_state"
    local instruction2 = "Press ESC to quit"

    local title_width = love.graphics.getFont():getWidth(title)
    local instruction1_width = love.graphics.getFont():getWidth(instruction1)
    local instruction2_width = love.graphics.getFont():getWidth(instruction2)

    love.graphics.print(title, (window_width - title_width) / 2, 100)
    love.graphics.print(instruction1, (window_width - instruction1_width) / 2, 140)
    love.graphics.print(instruction2, (window_width - instruction2_width) / 2, 180)
end

function state:unload()

end
return state
