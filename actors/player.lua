local lg = love.graphics

local shoot_len = 16
local blink_len = 8
local dead_len = 40

local player = {
    player = true,
    top = true,
    hitboxes = {{8.5, 7.5, 3}},
    blink = -100,
}
function player:init(x, y)
    self:setpos(x, y)
    self.blink = 100
    self.yolk_anim = self:new_anim("yolk", 1, true)
    self.white_anim = self:new_anim("white", 1, true)
end
function player:draw(artist)
    if self.yolk_anim.name == "yolk" then
        if self.blink > 0 then
            self.blink = self.blink - 1
            if self.blink == 0 then
                self.blink = math.floor(math.random() * 200)
                self.yolk_anim = self:new_anim("yolk_blink", blink_len)
            end
        end
    end
    artist.draw_anim(self.white_anim, self.x-self.dx, self.y-self.dy)
    artist.draw_anim(self.yolk_anim, self.x, self.y)
end
local color = {135, 182, 195}
function player:update(game)
    if self.yolk_anim.name == "yolk_die" then
        if self.yolk_anim.pos > dead_len then
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
    if self.yolk_anim.name == "yolk_shoot" then
        if self.yolk_anim.over then
            self.yolk_anim = self:new_anim("yolk", 1, true)
            self.white_anim = self:new_anim("white", 1, true)
        end
    else
        if game.buttons.a == 1 then
            game.spawn("bullet", self.x+9, self.y+4.5+self.dy*2,
                       self.dx/2+2, self.dy, color, true)
            self.yolk_anim = self:new_anim("yolk_shoot", shoot_len, false)
            self.white_anim = self:new_anim("white_shoot", shoot_len, false)
            self.blink = -100
        end
    end
    self:physics()
end
function player:collide(with)
    if not with.player then
        self.killme = true
    end
end
function player:die()
    if not self.dead then
        self.yolk_anim = self:new_anim("yolk_die", 10, true)
        self.dead = dead_len
    end
end
return player
