local boom = {}
function boom:init(x, y, color, num)
    self.color = color
    self.bits = {}
    self.timer = 300
    for i = 1,(num or 10) do
        local angle = math.random() * math.pi * 2
        local pow = 2.0 + 2*math.random() + 2*math.random()
        self.bits[i] = {x=x, y=y, dx=math.sin(angle)*pow, dy=math.cos(angle)*pow}
    end
end
function boom:update()
    self.timer = self.timer - 1
    self.killme = self.timer < 0
end
function boom:draw(artist)
    love.graphics.setColor(self.color)
    for i, bit in ipairs(self.bits) do
        artist.draw_sprite("bullet", 1, bit.x+bit.dx*3, bit.y+bit.dy*3)
        artist.draw_sprite("bullet", 2, bit.x-bit.dx, bit.y-bit.dy)
        artist.draw_sprite("bullet", 3, bit.x-bit.dx*3, bit.y-bit.dy*3)
        bit.x, bit.y = bit.x+bit.dx, bit.y+bit.dy
    end
    love.graphics.setColor(255,255,255)
end
return boom
