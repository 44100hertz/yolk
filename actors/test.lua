local lg = love.graphics
local test = {}
test.hitboxes = {{20, 20, 10}}
function test:update()
    self:physics()
end
function test:draw()
    lg.setColor(255, 0, 0)
    lg.circle("fill", self.x, self.y, 20, 20)
end
function test:collide()
end
function test:init(x, y, dy)
    self:setpos(x, y)
    self.dy = dy or 0
end
return test
