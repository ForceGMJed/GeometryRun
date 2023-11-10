Platform = Entity:extend()ss

function Platform:new(x,y)
    platform.super.new(self,x,y,"sprites/platform.png")
    self.materialStrength = 100
    self.name = "platform"

    self.gravity = 0
end