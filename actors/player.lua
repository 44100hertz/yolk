local game = require "game"

local shoot_len = 16
local blink_len = 8
local dead_len = 40

local player = {
    player = true,
    top = true,
    hitboxes = {{8.5, 7.5, 4}},
}
local color = {135, 182, 195}

function player:init(x, y)
    self:setpos(x, y)
    self.blink = 100
    self.anim = self:new_anim("yolk", 1, true)
    self.white_anim = self:new_anim("white", 1, true)
end
function player:draw(artist)
    if self.anim.name == "yolk" then
        self.blink = self.blink - 1
        if self.blink == 0 then
            self.blink = math.floor(math.random() * 200)
            self.anim = self:new_anim("yolk_blink", blink_len)
        end
    elseif self.anim.name == "yolk_blink" and self.anim.over == true then
        self.anim = self:new_anim("yolk", 1, true)
    end
    artist.draw_anim(self.white_anim, self.x-self.dx, self.y-self.dy)
    artist.draw_anim(self.anim, self.x, self.y)
end

function player:update()
    if self.anim.name == "yolk_die" then
        if self.anim.pos > dead_len then
            game.spawn("boom", self.x+9, self.y+4.5, color, 40)
            self.killme = true
        end
        return
    end
    local keynum = function (b)
        return game.buttons[b] and 1 or 0
    end
    self.dx = keynum "dr" - keynum "dl"
    self.dy = keynum "dd" - keynum "du"
    if self.anim.name == "yolk_shoot" then
        if self.anim.over then
            self.anim = self:new_anim("yolk", 1, true)
            self.white_anim = self:new_anim("white", 1, true)
        end
    else
        if game.buttons.a == 1 then
            game.spawn("bullet", self.x+9, self.y+4+self.dy,
                       self.dx+3, self.dy, color, true)
            self.anim = self:new_anim("yolk_shoot", shoot_len, false)
            self.white_anim = self:new_anim("white_shoot", shoot_len, false)
            self.blink = -100
        end
    end
    self:physics()
end
function player:collide(with)
    self:die()
end
function player:die()
    if not self.dead then
        self.anim = self:new_anim("yolk_die", 10, true)
        self.dead = dead_len
    end
end
return player
