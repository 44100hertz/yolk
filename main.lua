local scenes = require "scenes"

love.run = function ()
    local menu = require "menu"
    scenes.run(menu)
end
