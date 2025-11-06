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
require("src.classes.torch")

-- REQUIRE UTILS
utils = {}
utils.collisions = require("src.utils.collisions")
require("src.utils.gui")
require("src.utils.manager")

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
    -- Dust particles
    self.dust = {}
    for i = 1, 100 do
        table.insert(self.dust, {
            x = love.math.random(0, wW),
            y = love.math.random(0, wH),
            size = love.math.random(1 , 10)/10,
            speedX = love.math.random(-5, 5) / 20,  -- gentle horizontal drift
            speedY = love.math.random(-5, 5) / 20,  -- gentle vertical drift
        })
    end

    track:play()
    movementSFX:play()

    GUI:load()
    Player:load()
    spawnEntities()
    spawnOnceEntities()

    if IsMobile then
        love.window.setFullscreen(true)
        scaleGame()
    end
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
        World:update(dt)
        local desiredX = Player.x
        local desiredY = Player.y

        desiredX = math.max(wW/ self.scale / 2, math.min(desiredX, MapWidth - wW/ self.scale / 2))
        desiredY = math.max(wH/self.scale / 2, math.min(desiredY, MapHeight - wH/self.scale / 2))

        camera:move((desiredX - camera.x) * 0.1, (desiredY - camera.y) * 0.1)
        Player:update(dt)
        Fire.updateAll(dt)
        Blackhole.updateAll(dt)
        Block.updateAll(dt)
        Relic.updateAll(dt)
        Torch.updateAll(dt)

        GUI:update(dt)
        for _, d in ipairs(self.dust) do
            d.x = d.x + d.speedX
            d.y = d.y + d.speedY

            -- wrap around edges
            if d.x < 0 then d.x = love.graphics.getWidth() end
            if d.x > love.graphics.getWidth() then d.x = 0 end
            if d.y < 0 then d.y = love.graphics.getHeight() end
            if d.y > love.graphics.getHeight() then d.y = 0 end
        end
    end
end

function game:draw()
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

        local scaleX = screenWidth / imgWidth
        local scaleY = screenHeight / imgHeight

        local offsetX = -px * factor % imgWidth

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
    local lightX = (Player.x - camera.x) * self.scale + wW / 2
    local lightY = (Player.y - camera.y) * self.scale + wH / 2
 
    if self.shaking or self.blasting then
        dx = love.math.random(-1 * game.downBlast, 1 * game.downBlast)
        dy = love.math.random(-1, 1)
        LG.push()
    end

    camera:attach()
        for _, d in ipairs(self.dust) do
            LG.setColor(1, 1, 1, d.size)
            local camOffsetX = camera.x * 0.02
            local camOffsetY = camera.y * 0.02
            LG.circle("fill", d.x - camOffsetX, d.y - camOffsetY, d.size * 1.5)
        end
        LG.setColor(1, 1, 1, 1)
        love.graphics.setShader(DarknessShader)
        DarknessShader:send("lightPos", {lightX, lightY})
        DarknessShader:send("lightRadius", Player.lightIntensity * scale)
        DarknessShader:send("ambient", 0.2)

        Map:drawLayer(Map.layers["BGTiles"])
        Map:drawLayer(Map.layers["Base"])
        Block.drawAll()
        Relic.drawAll()
        love.graphics.setShader()

        Player:draw()
        Blackhole.drawAll()
        Torch.drawAll()
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


return game
