local mask = {
    hitboxes = {{5, 8.5, 6}},
}
function mask:init(x, y)
    self:setpos(x, y+30)
    self.dx = -0.5
    self.root_y = y
    self.body_anim = self:new_anim("mask_body", 8, true)
end
function mask:draw(artist)
    artist.draw_anim(self.body_anim, self.x, self.y)
    artist.draw_sprite("mask_face", 1, self.x, self.y)
end
function mask:update(game)
    if not game.offscreen_front(self.x, 1.0) then
        self.dy = self.dy + (self.root_y - self.y) * 0.001
        self:physics()
    end
end
return mask
