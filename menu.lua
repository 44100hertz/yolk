local menu = {}
local game = require "game"
local scenes = require "scenes"

game.load_level("test")

local lg = love.graphics
local img = lg.newImage("res/title.png")

menu.draw = function ()
    game.draw()
    lg.draw(img)
    if love.timer.getTime() % 0.5 < 0.25 then
        lg.printf("Press Enter", 0, _G.GAMEH*0.7, _G.GAMEW, "center")
    end
end

menu.update = function (buttons)
    if buttons.start then
        scenes.run(game)
    end
end

return menu
