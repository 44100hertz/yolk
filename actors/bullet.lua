local bullet = {}
function bullet:draw ()
    love.graphics.setColor(self.color)
    self:draw_sprite("bullet", 1, self.x, self.y)
    self:draw_sprite("bullet", 2, self.x-self.dx*2, self.y-self.dy*2)
    self:draw_sprite("bullet", 3, self.x-self.dx*3, self.y-self.dy*3)
    love.graphics.setColor(255,255,255,255)
end
function bullet:init(x, y, dx, dy, color, player)
    self:setpos(x, y)
    self.dx, self.dy = dx, dy
    self.color = color
    self.player = player
end
function bullet:update()
    self:physics()
    if self.dx > 0 and self:offscreen_front() then
        self.killme = true
    end
end
return bullet
