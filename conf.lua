_G.GAMEW, _G.GAMEH = 256, 160
--_G.DEBUG = true

love.conf = function (t)
    t.window.width = GAMEW*3
    t.window.height = GAMEH*3
    t.modules.physics = false
end
