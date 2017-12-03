local lg = love.graphics

local player = {}
player.player = true
player.hitboxes = {{0, 0, 8}}
function player:draw()
    lg.setColor(0, 128, 255)
    lg.circle("fill", self.x, self.y, 10)
end
function player:update(buttons)
    local keynum = function (b)
        return buttons[b] and 1 or 0
    end
    self.dx = keynum "dr" - keynum "dl"
    self.dy = keynum "dd" - keynum "du"
    self:physics()
end
return player
