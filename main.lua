local scenes = require "scenes"

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
            buttons[keymap[sc]] = 0
        end
    end,
    keyreleased = function (_, sc)
        if keymap[sc] then
            buttons[keymap[sc]] = false
        end
    end
}

love.run = function ()
    while true do
        for k,_ in pairs(buttons) do
            buttons[k] = buttons[k] and buttons[k]+1
        end
        love.event.pump()
        for name, a,b,c,d,e,f in love.event.poll() do
            if name == "quit" then
                return
            end
            if handlers[name] then
                handlers[name](a,b,c,d,e,f)
            end
        end
        scenes.update(buttons)
        scenes.draw()
    end
end
