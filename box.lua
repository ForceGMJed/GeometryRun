Box = Entity:extend()

function Box:new(x,y)
    Box.super.new(self,x,y,"sprites/box.png")
    self.materialStrength = 1
    self.name = "box"
    self.gravity = 850
end