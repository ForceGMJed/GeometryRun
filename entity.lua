Entity = Object:extend()

function Entity:new(x,y,image_path)
    
    self.x = x
    self.y = y
    self.spawnX = x
    self.spawnY = y
    self.image = love.graphics.newImage(image_path)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.lastX = x
    self.lastY = y

    self.materialStrength = 0
    
    self.tempStrengthX = 0
    self.tempStrengthY = 0
    self.name = ""


    -- Add the gravity and weight properties
    self.downwardsVelocity = 0
    --g is constant across all objects
    self.gravity = 900
end

function Entity:update(dt)

    --CACHE FIRST
    self.lastX = self.x
    self.lastY = self.y

    self.tempStrengthX = self.materialStrength
    self.tempStrengthY = self.materialStrength

    --THEN UPDATE GRAVITY!
    self.downwardsVelocity = self.downwardsVelocity + self.gravity*dt
    self.y = self.y + self.downwardsVelocity*dt

end

function Entity:draw()
    love.graphics.draw(self.image,self.x,self.y)
end

--each Entity instance can check collision with a target and itself
--only player will check collision with WALL , wall is stationary
function Entity:checkCollision(target)
    return self.x + self.width > target.x
    and self.x < target.x + target.width
    and self.y + self.height > target.y
    and self.y < target.y + target.height
end

function Entity:resolveCollision(target)


    --target's strength is always bigger than the caller (self)
    if self:checkCollision(target)  then

        --force the both of the collidingt objects to have the same strength, whoever highest( which will always be
        -- target!!!)
             
        --RESOLVE horizontal collision
        if self:isLastFrameVerticallyColliding(target) then


            if (target.tempStrengthX < self.tempStrengthX)then
        
                return target:resolveCollision(self)
        
            end   

            --lighter object inherits strength of stronger object
            self.tempStrengthX = target.tempStrengthX   
            --self coming from left
            if self.x + self.width/2 < target.x + target.width/2 then      

                if self:isAllowResolve(target,"left") and target:isAllowResolve(self,"right") then
                    self:resolve(target,"left")
                else
                    -- there is no collision resolved
                    return false
                end
                
                
            else
                if self:isAllowResolve(target,"right") and target:isAllowResolve(self,"left") then
                    self:resolve(target,"right")
                else
                    -- there is no collision resolved
                    return false
                end
                
                
            end
          

            --RESOLVE vertical collision
        elseif self:isLastFrameHorizontallyColliding(target) then

            if (target.tempStrengthY < self.tempStrengthY)then
        
                return target:resolveCollision(self)
        
            end   

            --lighter object inherits strength of stronger object
            self.tempStrengthY = target.tempStrengthY 
            --self coming from up
            if self.y + self.height/2 < target.y + target.height/2 then      
                if self:isAllowResolve(target,"up") and target:isAllowResolve(self,"down") then

                    self:resolve(target,"up")
                      --all entities will reset their downwards v
                    self.downwardsVelocity = 0
                
                else
                    -- there is no collision resolved 
                    return false
                end
                
               
              
            else
                if self:isAllowResolve(target,"down") and target:isAllowResolve(self,"up") then

                    self:resolve(target,"down")
                    
                else
                    -- there is no collision resolved
                    return false
                end
                
            end

    
        end 
        
        -- there is collision resolved
        return true

    end

    -- there is no collision between the 2 objects in this frame
    return false
end

function Entity:isLastFrameVerticallyColliding(target)
    return  self.lastY + self.height > target.lastY
    and self.lastY < target.lastY + target.height
end

function Entity:isLastFrameHorizontallyColliding(target)
    return self.lastX + self.width > target.lastX
    and self.lastX < target.lastX + target.width
end

function Entity:resolve(target,comingFrom)

    if comingFrom == "left" then
        self.x = self.x - (self.x+self.width - target.x)
        --print("moving ".. self.name .. " to the left")
    end
    if comingFrom == "right" then
        self.x = self.x + (target.x + target.width - self.x)
        --print("moving ".. self.name .. " to the right")
    end

    if comingFrom == "up" then
        self.y = self.y - (self.y + self.height - target.y)
        --print("moving ".. self.name .. " to the top")
    end

    if comingFrom == "down" then
        self.y = self.y + (target.y + target.height - self.y)
        --print("moving ".. self.name .. " to the bottem")
    end

end

--for anisotropic collision behaviour, must check 
function Entity:isAllowResolve(target,comingFrom)
    return true
end

