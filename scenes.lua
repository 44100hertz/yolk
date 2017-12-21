local lg = love.graphics
local scenes = {}

lg.setDefaultFilter("nearest", "nearest")
local internal = lg.newCanvas(_G.GAMEW, _G.GAMEH)

local buttons = {}
local keymap = {
    z     = "a",  x     = "b",
    i     = "du", k     = "dd",
    j     = "dl", l     = "dr",
    lshift= "a",  lalt  = "b",
    up    = "du", down  = "dd",
    left  = "dl", right = "dr",
    rctrl = "a",  rshift= "b",
    w     = "du", s     = "dd",
    a     = "dl", d     = "dr",
    ["return"] = "start",
}

local handlers = {
    keypressed = function (_, sc)
        if keymap[sc] then
            buttons[keymap[sc]] = 1
        end
    end,
    keyreleased = function (_, sc)
        if keymap[sc] then
            buttons[keymap[sc]] = false
        end
    end
}

local quitall
scenes.run = function (scene)
    while not quitall and not scene.update(buttons) do
        for k,_ in pairs(buttons) do
            buttons[k] = buttons[k] and buttons[k]+1
        end
        love.event.pump()
        for name, a,b,c,d,e,f in love.event.poll() do
            if name == "quit" then
                quitall = true
            elseif handlers[name] then
                handlers[name](a,b,c,d,e,f)
            end
        end
        internal:renderTo(function ()
                scene.draw()
        end)
        if _G.DEBUG and scene.draw_debug then
            scene.draw_debug(sx, sy)
        end
        lg.origin()
        local ww, wh = love.window.getMode()
        local sx, sy = ww/_G.GAMEW, wh/_G.GAMEH
        lg.draw(internal, 0, 0, 0, sx, sy)
        lg.present()
    end
end

return scenes
