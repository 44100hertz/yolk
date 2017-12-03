local sprites = {}

local lg = love.graphics
local sheet_def = require "res/sheets"

local images
local sheets

sprites.draw = function (name, frame, x, y)
    local iname, qx, qy, qw, qh = unpack(sheet_def[name])
    images[iname] = images[iname] or lg.newImage(iname)
    local image = images[iname]
    sheets[name] = sheets[name] or {}
    sheets[name][frame] = sheets[name][frame] or
        lg.newQuad(qx+qw*(frame-1), qy, qw, qh, image:getDimensions())
    lg.draw(image, sheets[name][frame], x, y)
end

sprites.clear = function ()
    images = {}
    sheets = {}
end

sprites.clear()
return sprites
