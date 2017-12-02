local game = require "game"

game.load_level("test")

love.update = function ()
    game.update()
end

love.draw = function ()
    game.draw()
end
