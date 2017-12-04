local lg = love.graphics

local shoot_frames = 6
local shoot_len = 16
local blink_frames = 4
local blink_len = 8

local player = {
    player = true,
    top = true,
    hitboxes = {{8.5, 7.5, 3}},
    blink = -100,
}
function player:init(x, y)
    self:setpos(x, y)
end
function player:draw()
    local yolk_x, yolk_y = self.x-self.dx, self.y-self.dy
    if self.cooldown then
        local frame = (shoot_len - self.cooldown)/shoot_len*shoot_frames
        frame = math.floor(frame + 1)
        self:draw_sprite("white", frame, self.x, self.y)
        self:draw_sprite("yolk", frame, yolk_x, yolk_y)
        self.blink = -100
        return
    else
        if self.blink > 0 then
            local frame = (blink_len - self.blink)/blink_len*blink_frames
            frame = math.floor(frame+1)
            self:draw_sprite("white", 1, self.x, self.y)
            self:draw_sprite("yolk_blink", frame, yolk_x, yolk_y)
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
    self:draw_sprite("white", 1, self.x, self.y)
    self:draw_sprite("yolk", 1, yolk_x, yolk_y)
end
function player:update(buttons)
    local keynum = function (b)
        return buttons[b] and 1 or 0
    end
    self.dx = keynum "dr" - keynum "dl"
    self.dy = keynum "dd" - keynum "du"
    if self.cooldown then
        self.cooldown = self.cooldown > 0 and self.cooldown-1 or false
    else
        if buttons.a == 1 then
            local col = {135, 182, 195}
            self:spawn("bullet", self.x+9, self.y+4.5+self.dy*2,
                       self.dx/2+2, self.dy, col, true)
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
return player
