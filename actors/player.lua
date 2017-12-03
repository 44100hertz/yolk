local lg = love.graphics

local cool_frames = 6
local cool_len = 16

local player = {}
player.player = true
player.hitboxes = {{8.5, 7.5, 3}}
function player:init(x, y)
    self:setpos(x, y)
end
function player:draw()
    local cool_frame = 1
    if self.cooldown then
        cool_frame = 1 + (cool_len - self.cooldown)/cool_len*cool_frames
        cool_frame = math.floor(cool_frame)
    end
    local yolk_x, yolk_y = self.x-self.dx, self.y-self.dy

    self:draw_sprite("white", cool_frame, self.x, self.y)
    self:draw_sprite("yolk", cool_frame, yolk_x, yolk_y)
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
            self:spawn("bullet", self.x+5, self.y+4.5, 2, self.dy, col, true)
            self.cooldown = cool_len
        end
    end
    self:physics()
end
return player
