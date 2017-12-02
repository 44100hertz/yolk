local lg = love.graphics

local game = require "game"

game.load_level("test")

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
            game.draw()
        end)
        lg.origin()
        local ww, wh = love.window.getMode()
        local sx, sy = ww/_G.GAMEW, wh/_G.GAMEH
        lg.draw(internal, 0, 0, 0, sx, sy)
        if _G.DEBUG then
            game.draw_hitboxes(sx, sy)
        end
        lg.present()
    end
end
