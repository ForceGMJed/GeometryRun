LongPlatform = Entity:extend()

function LongPlatform:new(x,y)
    LongPlatform.super.new(self,x,y,"sprites/LongPlatform.png")
    self.materialStrength = 100
    self.name = "LongPlatform"

    self.gravity = 0
end