Player = Entity:extend()


-----anim---------------
run = {}
run.frames ={}

table.insert(run.frames, love.graphics.newImage("sprites/player/player1.png"))
table.insert(run.frames, love.graphics.newImage("sprites/player/player2.png"))
table.insert(run.frames, love.graphics.newImage("sprites/player/player3.png"))
table.insert(run.frames, love.graphics.newImage("sprites/player/player4.png"))
table.insert(run.frames, love.graphics.newImage("sprites/player/player5.png"))
table.insert(run.frames, love.graphics.newImage("sprites/player/player6.png"))
table.insert(run.frames, love.graphics.newImage("sprites/player/player7.png"))
table.insert(run.frames, love.graphics.newImage("sprites/player/player8.png"))

run.currentFrame = 1
run.animationSpeed = 25

jump ={}
jump.frames ={}

table.insert(jump.frames, love.graphics.newImage("sprites/player/playerJump1.png"))
table.insert(jump.frames, love.graphics.newImage("sprites/player/playerJump2.png"))
table.insert(jump.frames, love.graphics.newImage("sprites/player/playerJump3.png"))
table.insert(jump.frames, love.graphics.newImage("sprites/player/playerJump4.png"))
table.insert(jump.frames, love.graphics.newImage("sprites/player/playerJump5.png"))
table.insert(jump.frames, love.graphics.newImage("sprites/player/playerJump6.png"))
table.insert(jump.frames, love.graphics.newImage("sprites/player/playerJump7.png"))

jump.currentFrame = 1
jump.animationSpeed = 75

-------------sfx-------------

jumpSound = love.audio.newSource("/sounds/jump.ogg", "static")
jumpSound:setVolume(0.2)

boxSound = love.audio.newSource("/sounds/box.ogg", "static")
boxSound:setVolume(0.4)


isPlayBoxSound = false

function Player:new(x,y)

    Player.super.new(self,x,y,"sprites/player/player1.png")
    self.materialStrength = 10
    self.name = "player"
    self.canJump = false

end


function Player:update(dt)

    -------------jump logic------------
    if love.keyboard.isDown("up") then
        self:jump()

    end
    
    --when player in mid air, dont allow jumps
    if self.lastY ~= self.y then
        self.canJump = false
    end


    --------movement logic------------

    --cache pre movement pos in base class!
    Player.super.update(self,dt)    

    if love.keyboard.isDown("left") then
        self.x = self.x - 200 * dt
    elseif love.keyboard.isDown("right") then
        self.x = self.x + 200 * dt
    end


    ------------animation logic---------
    if not self.canJump then
        --jump anim if canJump is false
        jump.currentFrame = jump.currentFrame + jump.animationSpeed*dt

        if jump.currentFrame> #jump.frames + 1 then
            jump.currentFrame = 1
        end
    else
        --walk anim if canJump is true
        run.currentFrame = run.currentFrame + run.animationSpeed*dt

        if run.currentFrame> #run.frames + 1 then
            run.currentFrame = 1
        end

    end

    
    ------------sfx updates(reset sfx, if collision happen, this bool will be overriden)------
    isPlayBoxSound = false
  
   
end


function Player:draw()

    if not self.canJump then
        --jump anim if canJump is false
        love.graphics.draw(jump.frames[math.floor(jump.currentFrame)], player.x,player.y,0,1,1)
    else
        --walk anim if canJump is true
        love.graphics.draw(run.frames[math.floor(run.currentFrame)], player.x,player.y,0,1,1)
    end
    if isPlayBoxSound then
        boxSound:play()
    else
        boxSound:stop()
    end
    
end

function Player:jump()
    
    if not self.canJump then
        return
    end
    jumpSound:play()
    self.downwardsVelocity = -350
    self.canJump =false

end

function Player:resolve(target,comingFrom)

    Player.super.resolve(self,target,comingFrom)
    
    --only player resets the jump bool
    if comingFrom == "up" then
        self.canJump = true

    end
 
end

---only enables collision if player is coming from "up" to the target and the target is a Barrier type
function Player:isAllowResolve(target,comingFrom)
    if target:is(Platform) or target:is(LongPlatform) then
        if comingFrom =="up" then
            return true
        end

        return false

    end

    if target:is(Box)  then
        if comingFrom =="right"  or comingFrom =="left"  then
            -- print("PLAY WOOD SOUND")
            isPlayBoxSound = true
            return true
        end

        return true

    end

    return true
end
