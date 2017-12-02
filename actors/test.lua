local lg = love.graphics
local test = {}
test.hitboxes = {{0, 0, 20}}
function test:draw()
    lg.setColor(255, 0, self.touched and 0 or 255)
    lg.circle("fill", self.x, self.y, 20)
    self.touched = false
end
function test:init(x, y, dy)
    self:setpos(x, y)
    self.dy = dy or 0
end
function test:collide()
    self.touched = true
end
return test
