function love.conf(t)
    t.console = true
end
--obj lib first!
--parents..
--childs..

Object = require "classic"

require "entity"
require "player"
require "wall"
require "box"
require "platform"
require "longPlatform"
require "invisibleBarrier"
lume = require "lume"


function love.load()

    -- game fields
    game =
    {
        state =
        {
            menu = false,
            tutorial = false,
            prep = false,
            playing = false,
            gameOver = false,
        }

    }

    WINDOWS_WIDTH = love.graphics.getWidth()
    WINDOWS_HEIGHT= love.graphics.getHeight()

    menuTextEntryDelay = 0.5
    menuTextFadeTimer = 0
    menuTextFadeTime = 1.5
    menuTextAlpha = 0
    menuTextFadeTimer = 0

    score = 0
    score_text = ""
    highscore_text = ""

    timer = 0

    finishLine = {}
    finishLine.x = 4150
    finishLine.y = 100



    ----ui fields-----

    fontPath = "/font/Xomai.ttf"

    boxIMG = love.graphics.newImage("/sprites/box.png")
    platformIMG = love.graphics.newImage("/sprites/platform.png")

    frontBG = love.graphics.newImage("/sprites/bg6.png")
    gameBG = love.graphics.newImage("/sprites/bg7.png")

    -----sfx------------
 
    interfaceSound = love.audio.newSource("/sounds/interface.ogg", "static")
    interfaceSound:setVolume(0.5)
    winSound = love.audio.newSource("/sounds/win.ogg", "static")
    winSound:setVolume(0.1)
    beepSound = love.audio.newSource("/sounds/beep.ogg", "static")
    beepSound:setVolume(0.4)
    bgm = love.audio.newSource("/sounds/bgm.ogg","stream")
    bgm:setVolume(0.3)
    bgm:setLooping(true)
    bgm:play()
    ----flag----
    flag = {}
    flag.flagIMG = love.graphics.newImage("/sprites/flagAnimation.png")
    flag.numberOfFrames = 5
    flag.flagWidth = 32
    flag.flagHeight = 50
    flag.currentFrame = 1 
    flag.flagQuads = {}
    flag.animationSpeed = 10
    flag.x = finishLine.x
    flag.y = finishLine.y


    for i=0,flag.numberOfFrames-1 do
        table.insert(flag.flagQuads,love.graphics.newQuad(i*flag.flagWidth, 0,
        flag.flagWidth, flag.flagHeight, flag.flagIMG:getWidth(), flag.flagIMG:getHeight()))
        print(i*flag.flagWidth)
    end
    
    

    -----------prep fields---------------

    prepTimer = 0
    prepTime = 3

    remainingBeepTimes = prepTime

    prepTimer = prepTime


    --------playing fields ui-------------

    pTextEntryDelay = 0.5
    pTextFadeTimer = 0
    pTextFadeTime = 1.5
    pTextAlpha = 0
    pTextFadeTimer = 0


    --Gameover fields
    goTextEntryDelay = 1
    goTextFadeTimer = 0
    goTextFadeTime = 1.5
    goTextAlpha = 0
    goTextFadeTimer = 0
    isNewHighScore = false

    -- PLAYER fields

    player = Player(-100,450) 

    --save data 

    if love.filesystem.getInfo("savedata.txt") then
        print("HAVE FILE")
        local file = love.filesystem.read("savedata.txt")
        local data = lume.deserialize(file)
        highscore = data.highscore
        highscore_text = formatScore(highscore)
        
    else
        highscore = 0
    end


    --map fields
    Barrier = InvisibleBarrier(-400,250)

    b1 = Box(150,500)
    b2 = Box(300,350)
    b3 = Box(1250,500)
    b4 = Box(1320,300)
    b5 = Box(2260,200)
    b6 = Box(2725,400)
    b7 = Box(2975,350)
    b8 = Box(3750,400)
    b9 = Box(4050,150)
    b10 = Box(3285,400)

    p = Platform(460,350)
    p1 = Platform(1120,400)
    p2 = LongPlatform(1320,370)
    p3 = Platform(1875,340)
    p4 = Platform(2090,310)
    p5 = Platform(2750,330)
    p6 = LongPlatform(3250,380) 
    p7 = Platform(3400,320)
    p8 = Platform(4100,340)
    p9 = Platform(3925,280)
    p10 = LongPlatform(4000,230)

    -- init all objs
    objects = {}
    table.insert(objects,Barrier)

    table.insert(objects,player)
    table.insert(objects,b1)
    table.insert(objects,b2)
    table.insert(objects,b3)
    table.insert(objects,b4)
    table.insert(objects,b5)
    table.insert(objects,b6)
    table.insert(objects,b7)
    table.insert(objects,b8)
    table.insert(objects,b9)
    table.insert(objects,b10)

    table.insert(objects,p)
    table.insert(objects,p1)
    table.insert(objects,p3)
    table.insert(objects,p2)
    table.insert(objects,p4)
    table.insert(objects,p5)
    table.insert(objects,p6)
    table.insert(objects,p7)
    table.insert(objects,p8)
    table.insert(objects,p9)
    table.insert(objects,p10)
    

    -- INIT tile map
    walls={}

    wallSize = 50
    postDesignWallOffsetAmount = {} 
    
    postDesignWallOffsetAmount.horiAmount = 14
    
    postDesignWallOffsetAmount.vertAmount = -1
    
    map = {

        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}


    }

    -- fix object position post map design--

    fixObjectPositionPostMapDesign()

    for i, row in ipairs(map) do

        for j, col in ipairs(row) do

            --print(i .."," .. j)
            if col == 1 then
                --print((j-1)*wallSize .. ",".. (i-1)*wallSize )
                table.insert(walls, Wall((j-1)*wallSize + 0, (i-1)*wallSize + 0))
            end

        end

    end

    -----init game state------
    clearGameState()
    game.state.menu = true
    love.window.setTitle("Geometry Run")

end

--- Input callback from Love, use the passed variable "key" to check for key name
function love.keypressed(key)


    if key == "f1" then
        saveGame()
    elseif key == "f2" then
        love.event.quit("restart")
    end

    if key == "escape" then
        love.event.quit()
        return
    end

    if game.state.menu then

        if key =="space" then
            clearGameState()
            interfaceSound:play()
            game.state.tutorial = true
        end 
        return
    end

    if game.state.tutorial then
 
        if key =="space" then
            clearGameState()
            interfaceSound:play()  
            game.state.prep = true
        end 
        return
    end


    if game.state.playing or game.state.gameOver then

        if key =="r" then
            hotRestart()
            clearGameState()
            game.state.prep = true
        end 
        return
    end

end

function love.update(dt)

    WINDOWS_WIDTH = love.graphics.getWidth()
    WINDOWS_HEIGHT= love.graphics.getHeight()

    if game.state.menu or game.state.tutorial then

        ---------UI ANIMATIONS----------
        if menuTextEntryDelay > 0 then
            menuTextEntryDelay = menuTextEntryDelay - dt
        end

        if menuTextEntryDelay < 0 then
            loopMenuValue(dt,menuTextFadeTime,menuTextAlpha)
        end
       
    end

    
    if game.state.prep then

        ---------UI ANIMATIONS----------
        countDown(dt)

    end

    if game.state.playing then

        ------------debug----------

        --print(player.x .. "," .. player.y)

        ---------flag updates--------------
        flag.currentFrame  = flag.currentFrame + flag.animationSpeed* dt
        if flag.currentFrame > flag.numberOfFrames + 1 then
            flag.currentFrame = 1
        end

    ----------------entity physics updates--------------
        for k, v in ipairs(objects) do

            v:update(dt)

        end

        for k, v in ipairs(walls) do

            v:update(dt)

        end

        --resolve all collisions before updating(the next user input,and update of lastX,Y)
        local isContinueCheck = true
        local limit = 0
        while isContinueCheck do
            isContinueCheck = false
            limit = limit +1

            if limit > 5 then
                break
            end

            for i = 1, #objects-1 do
                for j = 1+i, #objects do

                    local collision = objects[i]:resolveCollision(objects[j])
                    if collision then
                        isContinueCheck = true

            
                    end

                end
            end

            --HERE WE DONT DO -1, + i LOGIC BECAUSE WE ARE NOT CHECKING THE SAME LIST WITH ITSELF!
            for i, obj in ipairs(objects) do
                for j, wall in pairs(walls) do

                    local collision = obj:resolveCollision(wall)
                    if collision then
                        isContinueCheck = true
                 
                    end
                end
            end

        end

    -----------animation updates--------
        -- print("tick")

    -----------game updates------------
        timer =  timer + dt
        score = round(timer,3)
        score_text = formatScore(score)

        if player.x > flag.x - player.image:getWidth()/2 then
            
            winSound:play()
          
            if highscore == 0 or score < highscore  then
                highscore_text = score_text
                highscore = score
                isNewHighScore = true

                saveGame()
            
       
            end
 
            clearGameState()
            game.state.gameOver = true
        
        end

    ----------UI updates---------------

        loopPlayingValue(dt,pTextFadeTime,pTextAlpha)


    end


    if game.state.gameOver then

        if goTextEntryDelay > 0 then
            goTextEntryDelay = goTextEntryDelay - dt
        end

        if goTextEntryDelay < 0 then
            loopEndValue(dt,goTextFadeTime,goTextAlpha)
        end

    end


end

function love.draw()

    if game.state.menu then
    
        DrawBGImg(frontBG)

        love.graphics.setColor(0,0,0,1)
        changeFont(30)
        love.graphics.printf("Geometry Run", 0, WINDOWS_HEIGHT /2 - 30,WINDOWS_WIDTH,"center")

        changeFont(20)
        if menuTextEntryDelay < 0 then
            
            love.graphics.setColor(1,1,1,menuTextAlpha)
            love.graphics.printf("Press SpaceBar to Play", 0, WINDOWS_HEIGHT /2  ,WINDOWS_WIDTH,"center")
           
        end

        love.graphics.setColor(0,0,0,1)
        love.graphics.printf("Press ESC to quit", 0, WINDOWS_HEIGHT - 30  ,WINDOWS_WIDTH,"center")



    end
        
    if game.state.tutorial then

        color = util_RBGAtoDEC(243, 165, 251, 1)
        love.graphics.setBackgroundColor(color)


        changeFont(20)
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf("Arrow keys to move.", 0, WINDOWS_HEIGHT /2 - 60,WINDOWS_WIDTH,"center")

        ---box----

        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(boxIMG,WINDOWS_WIDTH/2 + 250, WINDOWS_HEIGHT/2 -30 -(0.75*(boxIMG:getHeight()/2)) ,0,0.75,0.75)
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf("Boxes are pushable.", 0, WINDOWS_HEIGHT /2 -30  ,WINDOWS_WIDTH,"center")

        ---platforms---

        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(platformIMG,WINDOWS_WIDTH/2 + 250, WINDOWS_HEIGHT/2  ,0,0.75,0.75)
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf("Platforms can be jumped onto from below.", 0, WINDOWS_HEIGHT / 2   ,WINDOWS_WIDTH,"center")
       
        if menuTextEntryDelay < 0 then
            
            love.graphics.setColor(1,1,1,menuTextAlpha)
            love.graphics.printf("Press SpaceBar to continue", 0, WINDOWS_HEIGHT /2 +90  ,WINDOWS_WIDTH,"center")
            
        end
        
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf("Press ESC to quit", 0, WINDOWS_HEIGHT - 30  ,WINDOWS_WIDTH,"center")

    end


    if game.state.prep then

        color = util_RBGAtoDEC(243, 165, 251, 1)
        love.graphics.setBackgroundColor(color)

        
        love.graphics.setColor(0,0,0,1)
        changeFont(20)
        love.graphics.printf("Get to the end as quickly as you can!", 0, WINDOWS_HEIGHT /2 -40 ,WINDOWS_WIDTH,"center")

        if highscore ~= 0 then
            love.graphics.setColor(0,0,0,1)
            changeFont(20)
            love.graphics.printf("HighScore: ".. highscore_text,0, WINDOWS_HEIGHT /2  ,WINDOWS_WIDTH,"center")
        end

        ----count down timer-----
        love.graphics.setColor(1,1,1,1)
        changeFont(25)
        love.graphics.printf(math.ceil(prepTimer),0, WINDOWS_HEIGHT /2 +40 ,WINDOWS_WIDTH,"center")
      
    end


    if game.state.playing then

    -----------BG IMAGE--------------
        DrawBGImg(gameBG)
        
    ---------PLAYER AND MAP-----------
        love.graphics.setColor(1,1,1,1)
        drawDynamicScene()


    ------------On screen ui-------------
        love.graphics.setColor(0,0,0,1)
        changeFont(30)
        love.graphics.printf(score_text, 0, 75 ,WINDOWS_WIDTH,"center")

        changeFont(20)
        love.graphics.setColor(1,1,1,pTextAlpha)
        love.graphics.printf("Press R to restart", 0, 125 ,WINDOWS_WIDTH,"center")

    end

 
    if game.state.gameOver then

        color = util_RBGAtoDEC(243, 165, 251, 1)
        love.graphics.setBackgroundColor(color)

        love.graphics.setColor(0,0,0,1)
       
        if isNewHighScore then
            changeFont(30)
            love.graphics.printf("NEW HIGH SCORE!", 0, WINDOWS_HEIGHT /2 -40 ,WINDOWS_WIDTH,"center")
        else
            love.graphics.printf("I think you can do better!", 0, WINDOWS_HEIGHT /2 - 40,WINDOWS_WIDTH,"center")
        end
        changeFont(20)
        love.graphics.printf("You finished in " .. score_text, 0, WINDOWS_HEIGHT /2 -00 ,WINDOWS_WIDTH,"center")

        changeFont(20)
        if goTextEntryDelay < 0 then
            love.graphics.setColor(1,1,1,goTextAlpha)
            love.graphics.printf("Press R to restart", 0, WINDOWS_HEIGHT /2 +40 ,WINDOWS_WIDTH,"center")
            
        end

        love.graphics.setColor(0,0,0,1)
        love.graphics.printf("Press ESC to quit", 0, WINDOWS_HEIGHT - 30  ,WINDOWS_WIDTH,"center")

    end

end

function changeFont(size)
    love.graphics.setNewFont(fontPath, size)
end

function formatScore(score)
    --print(score)
    local minutes = string.format("%02d",score/60)
    local _seconds = string.format("%02d",score%60)
    local milliSeconds = string.format("%03d", (score - math.floor(score))*1000)

    local s = minutes .. ":" .. _seconds .. ":" .. milliSeconds
    --print("finished in:" .. minutes..":".. _seconds .. ":" .. milliSeconds)
    return s

end

function saveGame()
    game.isSaveHighScore = false
   
    local data = {}

    data.highscore = highscore

    local serialized = lume.serialize(data)
    love.filesystem.write("savedata.txt", serialized)
    print("saved:" .. serialized)
end

function drawDynamicScene()

    love.graphics.push()

        dx = -player.x - player.image:getWidth()/2 + love.graphics.getWidth()/2
        dy = -player.y  - player.image:getHeight()/2 + love.graphics.getHeight()*2/3
        love.graphics.translate(dx,dy)

        -----------------draws the player here

        --animation--
        player:draw()
     
        -----------------draws the objects and map here

        --entities--
        for k, v in ipairs(objects) do
            if not v:is(Player) then
                v:draw()
            end

        end

        for k, v in ipairs(walls) do
            v:draw()
        end

        love.graphics.draw(flag.flagIMG, flag.flagQuads[math.floor(flag.currentFrame)],flag.x,flag.y)
        

    love.graphics.pop()
    --love.graphics.translate(-dx,-dy)
    --or love.graphics.origin()
end

function util_RBGAtoDEC(r, g, b, a)

    return {r / 255, g / 255, b / 255, a}

end

--forces a value to go from 1 to 0 back to 1 non stop
function loopMenuValue (dt,period)

    --forces timer to go from period/2 -> - period/2 in exactly 1 period
    if menuTextFadeTimer > -1 * period/2 then

        menuTextFadeTimer =  menuTextFadeTimer - dt

    else

        menuTextFadeTimer = period/2

    end

    menuTextAlpha = math.abs(menuTextFadeTimer/(period/2))

    if menuTextAlpha > 0.9 then
        menuTextAlpha = 0.9
    end

end

function loopPlayingValue (dt,period)

    --forces timer to go from period/2 -> - period/2 in exactly 1 period
    if pTextFadeTimer > -1 * period/2 then

        pTextFadeTimer =  pTextFadeTimer - dt

    else

        pTextFadeTimer = period/2

    end

    pTextAlpha = math.abs(pTextFadeTimer/(period/2))
    if pTextAlpha > 0.9 then
        pTextAlpha = 0.9
    end
    --print(menuTextAlpha)
end

function loopEndValue (dt,period)

    --forces timer to go from period/2 -> - period/2 in exactly 1 period
    if goTextFadeTimer > -1 * period/2 then

        goTextFadeTimer =  goTextFadeTimer - dt

    else

        goTextFadeTimer = period/2

    end

    goTextAlpha = math.abs(goTextFadeTimer/(period/2))
    if goTextAlpha > 0.9 then
        goTextAlpha = 0.9
    end
    --print(menuTextAlpha)
end

function countDown (dt)


    prepTimer  = prepTimer - dt

 

    if prepTimer < 0 then
        
        prepTimer = 0
        clearGameState()
        game.state.playing = true

        return

    end

    if remainingBeepTimes == math.ceil(prepTimer) then
        remainingBeepTimes = remainingBeepTimes - 1
        beepSound:play()
    end
    

end

function clearGameState()
    
    game.state.menu = false
    game.state.tutorial = false
    game.state.prep = false
    game.state.playing = false
    game.state.gameOver = false

end 

function hotRestart()

    isNewHighScore = false
    prepTimer = prepTime
    remainingBeepTimes = prepTime
    resetMap()
    timer = 0
    score = 0
    fixObjectPositionPostMapDesign()

end

function resetMap()

    for k, v in ipairs(objects) do
        v.x = v.spawnX
        v.y = v.spawnY
    end

    flag.x =finishLine.x
    flag.y = finishLine.y

end


function round(n, k) k = 10^(k or 0) return math.floor(n*k+.5)/k end

function fixObjectPositionPostMapDesign ()

    for i, v in ipairs(objects) do
        v.x = v.x + postDesignWallOffsetAmount.horiAmount*wallSize
        v.y = v.y + postDesignWallOffsetAmount.vertAmount*wallSize
    end

    flag.x = flag.x + postDesignWallOffsetAmount.horiAmount*wallSize
    flag.y = flag.y + postDesignWallOffsetAmount.vertAmount*wallSize

end


function DrawBGImg(img)
    love.graphics.setColor(1,1,1,1)
    local scaleX = WINDOWS_WIDTH/img:getWidth()
    local scaleY = WINDOWS_HEIGHT/img:getHeight()
    love.graphics.draw(img,0,0,0,scaleX,scaleY)
end