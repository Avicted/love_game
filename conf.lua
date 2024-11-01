local settings = require("settings")

function love.conf(t)
    t.window.title = settings.title
    t.window.width = settings.width
    t.window.height = settings.height
    t.window.resizable = settings.resizable
end
