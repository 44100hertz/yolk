local game = {}
local artist = require "artist"
local lg = love.graphics
local actors
local scroll, scroll_rate
local level

local base_actor = {
    x=0, y=0, dx=0, dy=0,
    hitboxes = {},
}
function base_actor:setpos (x, y)
    self.x, self.y = x ,y
end
function base_actor:init(x, y) self:setpos(x, y) end
function base_actor:physics ()
    self.x = self.x + self.dx
    self.y = self.y + self.dy
end
function base_actor:update () self:physics () end
function base_actor:die () self.killme = true end
function base_actor:draw () end
function base_actor:collide () end
function base_actor:new_anim (...) return artist.new_anim(...) end

local player
game.spawn = function (name, ...)
    local actor = dofile("actors/" .. name .. ".lua")
    setmetatable(actor, {__index = base_actor})
    actor:init(...)
    actors[#actors+1] = actor
    return actor
end

game.offscreen_front = function (x, thresh)
    return x > scroll + _G.GAMEW * (thresh or 1.5)
end

game.load_level = function (name)
    scroll = 0
    scroll_rate = 0.25
    actors = {}
    level = dofile("levels/" .. name .. ".lua")
    for _,actor in ipairs(level.actors) do
        game.spawn(unpack(actor))
    end
    player = game.spawn("player", 20, _G.GAMEH/2)
end

local check_collision
game.update = function (buttons)
    game.buttons = buttons
    scroll = scroll + scroll_rate
    player.x = player.x + scroll_rate
    for i = 1,#actors do
        for j = i+1,#actors do
            check_collision(actors[i], actors[j])
        end
    end
    for i,actor in ipairs(actors) do
        actor:update()
    end
    if player.x < scroll then
        player.x = scroll
    end
    if player.y < -8 or player.y > _G.GAMEH-8 then
        player:die()
    end
    for i,actor in ipairs(actors) do
        if actor.killme then
            actor:die()
            actors[i] = actors[#actors]
            actors[#actors] = nil
        end
    end
end

local border = {}
border.image = lg.newImage("res/border.png")
border.image:setWrap("repeat", "clamp")
border.w,border.h = border.image:getDimensions()
border.quad = lg.newQuad(0, 0, _G.GAMEW+border.w, border.h, border.w, border.h)

game.draw = function ()
    lg.setColor(255,255,255,255)
    lg.clear(level.bgcolor)
    local border_x = math.floor(-scroll*2 % border.w - border.w)
    lg.draw(border.image, border.quad, border_x, -border.h/2)
    lg.draw(border.image, border.quad, border_x, _G.GAMEH-border.h/2)
    lg.translate(-scroll, 0)
    for i,actor in ipairs(actors) do
        if not actor.top then
            actor:draw(artist)
        end
    end
    for i,actor in ipairs(actors) do
        if actor.top then
            actor:draw(artist)
        end
    end
end

check_collision = function (a, b)
    if a.player == b.player or
       not a.hitboxes or not b.hitboxes
    then
        return
    end
    for _,ha in ipairs(a.hitboxes) do
        for _,hb in ipairs(b.hitboxes) do
            local dist_x = (a.x + ha[1]) - (b.x + hb[1])
            local dist_y = (a.y + ha[2]) - (b.y + hb[2])
            local thresh = ha[3] + hb[3]
            if dist_x*dist_x + dist_y*dist_y < thresh*thresh then
                a:collide(b)
                b:collide(a)
                return
            end
        end
    end
end

game.draw_hitboxes = function (sx, sy)
    lg.push()
    lg.translate(-scroll*sx, 0)
    lg.scale(sx, sy)
    lg.setLineWidth(0.2)
    for _,actor in ipairs(actors) do
        if actor.player then
            lg.setColor(0, 255, 255)
        else
            lg.setColor(255, 255, 0)
        end
        for _,hitbox in ipairs(actor.hitboxes) do
            lg.circle("line", actor.x + hitbox[1], actor.y + hitbox[2], hitbox[3], 40)
        end
    end
    lg.pop()
end

return game
