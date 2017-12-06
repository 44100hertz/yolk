local game = require "game"
local mask = {
    hitboxes = {{9, 8, 6}},
}
function mask:init(x, y)
    self:setpos(x, y+30)
    self.dx = -0.5
    self.root_y = y
    self.body_anim = self:new_anim("mask_body", 8, true)
end
function mask:draw(artist)
    artist.draw_anim(self.body_anim, self.x, self.y)
    artist.draw_sprite("mask_face", 1, self.x, self.y+self.dy*2)
end
function mask:update()
    if not game.offscreen_front(self.x, 1.0) then
        self.dy = self.dy + (self.root_y - self.y) * 0.001
        self:physics()
    end
end
function mask:collide(with)
    self.killme = true
    game.spawn("boom", self.x, self.y, {0,0,0}, 10)
end
return mask
