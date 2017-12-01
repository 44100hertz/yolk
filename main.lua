local level = dofile "levels/test.lua"
local actors = {}
local base_actor = {
    x=0, y=0, dx=0, dy=0,
    hitboxes = {},
}
function base_actor:init () end
function base_actor:physics ()
    self.x = self.x + self.dx
    self.y = self.y + self.dy
end
function base_actor:update () self:physics() end
function base_actor:die () end
function base_actor:draw () end

local add_actor = function (name, x, y, ...)
    local actor = dofile("actors/" .. name .. ".lua")
    setmetatable(actor, {__index = base_actor})
    actor.x, actor.y = x, y
    actor:init(...)
    actors[#actors+1] = actor
end

local load_level = function (name)
    local level = dofile("levels/" .. name .. ".lua")
    for _,actor in ipairs(level.actors) do
        add_actor(unpack(actor))
    end
end

load_level("test")

love.update = function ()
    for i,actor in ipairs(actors) do
        actor:update() 
    end
    for i,actor in ipairs(actors) do
        if actor.killme then
            actor:die()
            actors[#actors-1] = actors[i]
        end
    end
end

love.draw = function ()
    for i,actor in ipairs(actors) do
        actor:draw() 
    end
end
