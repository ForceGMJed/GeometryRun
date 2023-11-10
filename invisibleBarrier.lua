InvisibleBarrier = Entity:extend()

function InvisibleBarrier:new(x,y)
    InvisibleBarrier.super.new(self,x,y,"sprites/invisibleBarrier.png")
    self.materialStrength = 1000
    self.name = "InvisibleBarrier"

    self.gravity = 0
end