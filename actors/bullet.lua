local bullet = {}
function bullet:draw ()
    love.graphics.setColor(self.color)
    self:draw_sprite("bullet", 1, self.x+self.dx, self.y+self.dy)
    self:draw_sprite("bullet", 2, self.x, self.y)
    self:draw_sprite("bullet", 3, self.x-self.dy, self.y-self.dy)
    love.graphics.setColor(255,255,255,255)
end
function bullet:init(x, y, dx, dy, color, player)
    self:setpos(x, y)
    self.dx, self.dy = dx, dy
    self.color = color
    self.player = player
end
return bullet
