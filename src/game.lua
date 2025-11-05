game = {
    background = LG.newImage("assets/vfx/loading/background.png"),
    scale = scale * 2,
    shaking = false,
    blasting = false,
    blastTime = 0,
    downBlast = 1,
    backgroundLayers = {
        layer3 = LG.newImage("assets/vfx/parallex/layer3.png"),
        layer2 = LG.newImage("assets/vfx/parallex/layer2.png"),
        layer1 = LG.newImage("assets/vfx/parallex/layer1.png"),
    },
    introfadeTimer = 0
}

local STI = require("src.libs.sti")
-- REQUIRE LIBRARIES
anim8 = require 'src.libs.anim8'
Camera = require 'src.libs.camera'
-- REQUIRE CLASSES
require("src.classes.player")
require("src.classes.fire")
require("src.classes.blackhole")
require("src.classes.block")
require("src.classes.relic")

-- REQUIRE UTILS
local utils = {}
utils.collisions = require("src.utils.collisions")
require("src.utils.gui")

-- Sounds and Tracks
introTrack = love.audio.newSource("assets/sfx/intro.wav", "stream")
introTrack:setLooping(true)
track = love.audio.newSource("assets/sfx/bg.mp3", "stream")
track:setLooping(true)
movementSFX = love.audio.newSource("assets/sfx/movement.mp3", "static")
movementSFX:setVolume(0.5)
movementSFX:setLooping(true)

function game:load()
    Map = STI("assets/map/1.lua", { "box2d" })
    World = love.physics.newWorld(0, 2000)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    Map.layers.entity.visible = false
    Map.layers.checkpoints.visible = false
    Map.layers.cutscene.visible = false
    MapWidth = Map.layers.Base.width * 32
    MapHeight = Map.layers.Base.height * 32

    DarknessShader = love.graphics.newShader("src/shaders/darkness.glsl")

    camera = Camera(Player.x, Player.y, game.scale)

    self.time = 0
    track:play()
    movementSFX:play()

    -- fire1 = Fire.new(100, 100)
    -- Blackhole1 = Blackhole.new(200, 200)
    -- Stone1 = Block.new(400, 100)
    GUI:load()
    Player:load()
    spawnEntities()
    spawnOnceEntities()
end

function game:update(dt)
    self.time = self.time + dt

    hitCheckpoints()
    cutsceneManager()
    if not paused then
        if self.introfadeTimer < 1 then
            self.introfadeTimer = self.introfadeTimer + (.5 * dt)
        end
        if self.blastTime >= 0 then
            self.blasting = true
            self.blastTime = self.blastTime - dt
        else
            self.blasting = false
            self.downBlast = 1
        end
        -- if Joystick then
        --     jAxes[1], jAxes[2], jAxes[3], jAxes[4] = Joystick:getAxes() -- lH, lV, rH, rV
        -- else
        --     for i = 1, 4 do
        --         jAxes[i] = 0
        --     end
        -- end
        -- Camera:update(dt)
        World:update(dt)
        local desiredX = Player.x
        local desiredY = Player.y

        -- Clamp
        desiredX = math.max(wW/ self.scale / 2, math.min(desiredX, MapWidth - wW/ self.scale / 2))
        desiredY = math.max(wH/self.scale / 2, math.min(desiredY, MapHeight - wH/self.scale / 2))

        camera:move((desiredX - camera.x) * 0.1, (desiredY - camera.y) * 0.1)
        Player:update(dt)
        Fire.updateAll(dt)
        Blackhole.updateAll(dt)
        Block.updateAll(dt)
        Relic.updateAll(dt)
        GUI:update(dt)
    end
end

function game:draw()


    -- Draw text
    LG.push()
    local text = "Escape the Void. Reach the Core. Don't fight it, RUN!"
    local textWidth = paragraph:getWidth(text)
    local textHeight = paragraph:getHeight()

    LG.setFont(paragraph)
    LG.setColor(1, 1, 1, self.introfadeTimer/1)
    LG.print(text, (wW - textWidth) / 2, wH - textHeight - 50)


    LG.draw(self.background, 0, 0, 0, self.scale, self.scale)
    local px = Player.x
    local py = Player.y
    local screenWidth = LG.getWidth()
    local screenHeight = LG.getHeight()

    local function drawParallax(layer, factor)
        local img = self.backgroundLayers[layer]
        local imgWidth, imgHeight = img:getDimensions()

        -- Calculate scaling to fit screen
        local scaleX = screenWidth / imgWidth
        local scaleY = screenHeight / imgHeight

        -- Parallax offset
        local offsetX = -px * factor % imgWidth
        -- local offsetY = -py * factor % imgHeight

        -- Draw 4 tiles to fill screen (to handle scrolling)
        for i = -1, 1 do
            for j = -1, 1 do
                LG.draw(img, offsetX + i * imgWidth * scaleX, j * imgHeight * scaleY, 0, scaleX, scaleY)
            end
        end
    end
    LG.setBlendMode("alpha", "premultiplied")



    drawParallax("layer3", 0.1)
    drawParallax("layer2", 0.2)
    drawParallax("layer1", 0.4)

    LG.setBlendMode("alpha")
    local dx = 0
    local dy = 0
    local lightX = (Player.x - camera.x) * self.scale  + (dx or 0)
    local lightY = (Player.y - camera.y) * self.scale  + (dy or 0)

    if self.shaking or self.blasting then
        dx = love.math.random(-1 * game.downBlast, 1 * game.downBlast)
        dy = love.math.random(-1, 1)
        LG.push()
    end

    
    -- DarknessShader:send("ambient", 0.2)

    camera:attach()

        love.graphics.setShader(DarknessShader)
        DarknessShader:send("lightPos", {lightX, lightY})
        DarknessShader:send("lightRadius", Player.lightIntensity * scale)
        Map:drawLayer(Map.layers["BGTiles"])
        Map:drawLayer(Map.layers["Base"])
        love.graphics.setShader()
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", lightX, lightY, 10)
        love.graphics.setColor(1, 1, 1)

        Player:draw()
        Blackhole.drawAll()
        Block.drawAll()
        Relic.drawAll()
        Fire.drawAll()
    camera:detach()
    if self.shaking  or self.blasting then
        LG.pop()
    end
    GUI:draw()
    LG.pop()
end

function game:keypressed(key)
    Player:keyboardInput(key)
    if key == "r" then
        Player:die()
    end

    if key == "escape" then
        paused = not paused
        if paused then
            track:pause()
            movementSFX:pause()
        else
            track:play()
            movementSFX:play()
        end
    end
end

function game:gamepadpressed(joystick, button)
    Player:gamepadInput(button)
end


function game:touchpressed(id, x, y, dx, dy, pressure)
    IsMobile = true
end

function game:focus(f)
    if f then
        print("Window is focused.")
        track:play()
        paused = false
    else
        print("Window is not focused.")
        track:pause()
        paused = true
    end
end

function beginContact(a, b, collision)
    utils.collisions:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    utils.collisions:endContact(a, b, collision)
end

function spawnEntities(args)
    for i, v in ipairs(Map.layers.entity.objects) do
        if v.name == "Fire" then
            Fire.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.name == "Blackhole" then
            Blackhole.new(v.x + v.width / 2, v.y + v.height / 2, math.random(50, 100), math.random(1, 5))
        elseif v.name == "Block" then
            Block.new(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end

function spawnOnceEntities()
    for i, v in ipairs(Map.layers.entity.objects) do
        if v.name == "Relic" then
            Relic.new(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end

function deleteEntities()
    Fire.clear()
    Blackhole.clear()
    Block.clear()
end

function hitCheckpoints()
    for i, v in ipairs(Map.layers.checkpoints.objects) do
        if Player.x > v.x and Player.x < v.x + v.width and Player.y > v.y and Player.y < v.y + v.height then
            if Player.checkpointX == v.x + v.width / 2 and Player.checkpointY == v.y + v.height / 2 then
                return
            end
            Player.checkpointX = v.x + v.width / 2
            Player.checkpointY = v.y + v.height / 2
        end
    end
end

function cutsceneManager()
    for i, v in ipairs(Map.layers.cutscene.objects) do
        if Player.x > v.x and Player.x < v.x + v.width and Player.y > v.y and Player.y < v.y + v.height then
            if v.started then return end
            game.setScene(v.name)
            print(v.name)
            v.started = true
        end
    end
end

return game
