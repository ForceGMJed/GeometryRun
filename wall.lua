Wall = Entity:extend()

function Wall:new(x,y)

    Wall.super.new(self,x,y,"sprites/wall.png")
    self.materialStrength = 100
    self.name = "wall"

    self.gravity = 0

end