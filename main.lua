local lg = love.graphics

local game = require "game"

game.load_level("test")

local buttons = {}
local keymap = {
    z     = "a",  x     = "b",
    lshift= "a",  lalt  = "b",
    up    = "du", down  = "dd",
    left  = "dl", right = "dr",
    i     = "du", k     = "dd",
    j     = "dl", l     = "dr",
    rctrl = "a",  rshift= "b",
    w     = "du", s     = "dd",
    a     = "dl", d     = "dr",
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

lg.setDefaultFilter("nearest", "nearest")
local internal = lg.newCanvas(_G.GAMEW, _G.GAMEH)

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
        game.update(buttons)
        lg.clear()
        internal:renderTo(function ()
            lg.clear()
            game.draw()
        end)
        local ww, wh = love.window.getMode()
        lg.draw(internal, 0, 0, 0, ww/_G.GAMEW, wh/_G.GAMEH)
        lg.present()
    end
end
