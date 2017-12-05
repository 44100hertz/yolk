local artist = {}

local lg = love.graphics
local sheet_def = require "res/sheets"

local images
local sheets

local round = function (x)
    return math.floor(x+0.5)
end

artist.draw_sprite = function (name, frame, x, y, ...)
    local image, quad = artist.get_frame(name, frame)
    lg.draw(image, quad, round(x), round(y), ...)
end

artist.batch = function (batch, name, frame, x, y, ...)
    local _, quad = artist.get_frame(name, frame)
    batch:add(quad, round(x), round(y), ...)
end

artist.new_batch = function (name, ...)
    local iname = sheet_def[name][1]
    return lg.newSpriteBatch(artist.get_image(iname), ...)
end

artist.get_image = function (name)
    images[name] = images[name] or lg.newImage(name)
    return images[name]
end

artist.get_frame = function (name, frame)
    local iname, qx, qy, qw, qh = unpack(sheet_def[name])
    local image = artist.get_image(iname)
    sheets[name] = sheets[name] or {}
    sheets[name][frame] = sheets[name][frame] or
        lg.newQuad(qx+qw*(frame-1), qy, qw, qh, image:getDimensions())
    return images[iname], sheets[name][frame]
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
