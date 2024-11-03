local settings = require("settings")

function love.conf(t)
    t.version = "11.5" -- The LÖVE version this game was made for (string)
    t.console = false -- Attach a console (boolean, Windows only)

    t.window.title = settings.title
    t.window.width = settings.width
    t.window.height = settings.height
    t.window.resizable = settings.resizable
end
