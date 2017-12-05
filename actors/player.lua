local lg = love.graphics

local shoot_frames = 6
local shoot_len = 16
local blink_frames = 4
local blink_len = 8
local dead_frames = 5
local dead_len = 40

local player = {
    player = true,
    top = true,
    hitboxes = {{8.5, 7.5, 3}},
    blink = -100,
}
function player:init(x, y)
    self:setpos(x, y)
end
function player:draw(artist)
    local yolk_x, yolk_y = self.x-self.dx, self.y-self.dy
    if self.dead then
        local sx, sy = math.random()*2, math.random()*2
        artist.draw_sprite("white", 1, self.x+sx, self.y+sy)
        local frame = math.floor(self.dead/2) % dead_frames + 1
        artist.draw_sprite("yolk_hurt", frame, self.x, self.y)
        return
    end
    if self.cooldown then
        local frame = (shoot_len - self.cooldown)/shoot_len*shoot_frames
        frame = math.floor(frame + 1)
        artist.draw_sprite("white", frame, self.x, self.y)
        artist.draw_sprite("yolk", frame, yolk_x, yolk_y)
        self.blink = -100
        return
    else
        if self.blink > 0 then
            local frame = (blink_len - self.blink)/blink_len*blink_frames
            frame = math.floor(frame+1)
            artist.draw_sprite("white", 1, self.x, self.y)
            artist.draw_sprite("yolk_blink", frame, yolk_x, yolk_y)
            self.blink = self.blink - 1
            if self.blink == 0 then
                self.blink = math.floor(math.random() * -200)
            end
            return
        else
            self.blink = self.blink + 1
            if self.blink == 0 then
                self.blink = blink_len
            end
        end
    end
    artist.draw_sprite("white", 1, self.x, self.y)
    artist.draw_sprite("yolk", 1, yolk_x, yolk_y)
end
local color = {135, 182, 195}
function player:update(game)
    if self.dead then
        self.dead = self.dead - 1
        if self.dead == 0 then
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
    if self.cooldown then
        self.cooldown = self.cooldown > 0 and self.cooldown-1 or false
    else
        if game.buttons.a == 1 then
            game.spawn("bullet", self.x+9, self.y+4.5+self.dy*2,
                       self.dx/2+2, self.dy, color, true)
            self.cooldown = shoot_len
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
        self.dead = dead_len
    end
end
return player
