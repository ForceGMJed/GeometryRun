Platform = Entity:extend()

function Platform:new(x,y)
    Platform.super.new(self,x,y,"sprites/platform.png")
    self.materialStrength = 100
    self.name = "platform"

    self.gravity = 0
end