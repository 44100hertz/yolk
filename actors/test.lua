local lg = love.graphics
local test = {}
test.hitboxes = {{50, 50, 100}}
function test:draw()
    lg.setColor(255, 0, self.col)
    lg.circle("fill", self.x, self.y, 100, 100)
    self.col = 0
end
function test:collide()
    self.col = 255
end
function test:init(x, y, dy)
    self:setpos(x, y)
    self.col = 0
    self.dy = dy or 0
end
return test
