local artist = {}

local lg = love.graphics
local sheet_def = require "res/sheets"

local images
local sheets

artist.draw_sprite = function (name, frame, x, y)
    local iname, qx, qy, qw, qh = unpack(sheet_def[name])
    images[iname] = images[iname] or lg.newImage(iname)
    local image = images[iname]
    sheets[name] = sheets[name] or {}
    sheets[name][frame] = sheets[name][frame] or
        lg.newQuad(qx+qw*(frame-1), qy, qw, qh, image:getDimensions())
    lg.draw(image, sheets[name][frame], math.floor(x+0.5), math.floor(y+0.5))
end

artist.new_anim = function (name, len, loop)
    return {name=name, frames=sheet_def[name][6],
            len=len, loop=loop, over=false, pos=0,
    }
end
artist.inc_anim = function (anim)
    local frame = 1 + math.floor((anim.pos % anim.len)/anim.len*anim.frames)
    anim.pos = anim.pos + 1
    if anim.pos >= anim.len then
        anim.over = true
        if not anim.loop then
            anim.pos = anim.len
        end
    end
    return frame
end
artist.draw_anim = function (anim, ...)
    local frame = artist.inc_anim(anim)
    artist.draw_sprite(anim.name, frame, ...)
end

artist.clear = function ()
    images = {}
    sheets = {}
end

artist.clear()
return artist
