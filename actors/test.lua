local lg = love.graphics
local test = {}
test.hitboxes = {"circle", 100, 100}
function test:draw()
    lg.setColor(255, 0, 0)
    lg.circle("fill", self.x, self.y, 100, 100)
end
return test
