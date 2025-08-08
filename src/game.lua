local game = {
    background = love.graphics.newImage("assets/vfx/loading/background.png"),
    scale = scale + 2,
    backgroundLayers = {
        layer3 = love.graphics.newImage("assets/vfx/parallex/layer3.png"),
        layer2 = love.graphics.newImage("assets/vfx/parallex/layer2.png"),
        layer1 = love.graphics.newImage("assets/vfx/parallex/layer1.png"),
    }
}
if wW/wH > 2 then
    game.scale = scale + 2.3
end
local STI = require("src.libs.sti")
-- REQUIRE LIBRARIES
anim8 = require 'src.libs.anim8'
Camera = require 'src.libs.camera'
-- REQUIRE CLASSES
require("src.classes.player")
require("src.classes.fire")
require("src.classes.blackhole")
require("src.classes.block")

-- REQUIRE UTILS
local utils = {}
utils.collisions = require("src.utils.collisions")
require("src.utils.gui")

-- Soundss and Tracks
track = love.audio.newSource("assets/sfx/bg.mp3", "stream")

function game:load()
    Map = STI("assets/map/1.lua", {"box2d"})
    World = love.physics.newWorld(0, 2000)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
        Map.layers.entity.visible = false
    MapWidth = Map.layers.Base.width * 32
    MapHeight = Map.layers.Base.height * 32
    track:play()

    -- fire1 = Fire.new(100, 100)
    -- Blackhole1 = Blackhole.new(200, 200)
    -- Stone1 = Block.new(400, 100)

    GUI:load()
    Player:load()
    spawnEntities()
end

function game:update(dt)
    if not paused then
           if Joystick then
        jAxes[1], jAxes[2], jAxes[3], jAxes[4] = Joystick:getAxes() -- lH, lV, rH, rV
    end
    Camera:update(dt)
    World:update(dt)
    Camera:setPosition(Player.x, Player.y)
    Player:update(dt)
    Fire.updateAll(dt)
    Blackhole.updateAll(dt)
    Block.updateAll(dt)
    GUI:update(dt) 
    end

end

function game:draw()
    love.graphics.draw(self.background, 0, 0, 0, self.scale, self.scale)
        local px = Player.x
    local py = Player.y
        local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

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
                love.graphics.draw(img, offsetX + i * imgWidth * scaleX, j * imgHeight * scaleY, 0, scaleX, scaleY)
            end
        end
    end

    drawParallax("layer3", 0.05)
    drawParallax("layer2", 0.15)
    drawParallax("layer1", 0.25)

    Map:draw(-Camera.x, -Camera.y, self.scale, self.scale)
    Camera:apply()
    Player:draw()
    Fire.drawAll()
    Blackhole.drawAll()
    Block.drawAll()
    Camera:clear()
    GUI:draw()
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
        else
            track:play()
        end
    end
end
function game:gamepadpressed(joystick, button)
    isMobile = false
    Player:gamepadInput(button)
end
function game:mousepressed(x, y, button)
    GUI:mousepressed(x, y, button)
end 
function game:touchpressed(id, x, y, dx, dy, pressure)
    isMobile = true
end

function game:focus(f)
    if f then
        print("Window is focused.")
        track:play()
    else
        print("Window is not focused.")
        track:pause()
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
            Fire.new(v.x + v.width/2, v.y+ v.height/2)
        elseif v.name == "Blackhole" then
            Blackhole.new(v.x + v.width/2, v.y+ v.height/2)
        elseif v.name == "Block" then
            Block.new(v.x, v.y)
        end
    end
end
return game
