local game = {
    background = love.graphics.newImage("assets/vfx/loading/background.png"),
    scale = scale + 1
}
if love.system.getOS() == "Android" then
    game.scale = scale + 1.3
end
local STI = require("src.libs.sti")
-- REQUIRE LIBRARIES
anim8 = require 'src.libs.anim8'
Camera = require 'src.libs.camera'
-- REQUIRE CLASSES
require("src.classes.player")
require("src.classes.fire")
require("src.classes.blackhole")

-- REQUIRE UTILS
local utils = {}
utils.collisions = require("src.utils.collisions")
require("src.utils.gui")

-- Soundss and Tracks
track = love.audio.newSource("assets/sfx/bg.mp3", "stream")

function game:load()
    Map = STI("assets/map/1.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    MapWidth = Map.layers.Base.width * 32
    track:play()

    fire1 = Fire.new(100, 100)
    Blackhole1 = Blackhole.new(200, 200)
    GUI:load()
    Player:load()
end

function game:update(dt)
    if Joystick then
        jAxes[1], jAxes[2], jAxes[3], jAxes[4] = Joystick:getAxes() -- lH, lV, rH, rV
    end
    World:update(dt)
    Camera:setPosition(Player.x, 0)
    Player:update(dt)
    Fire.updateAll(dt)
    Blackhole.updateAll(dt)
    GUI:update(dt)
end

function game:draw()
    love.graphics.draw(self.background, 0, 0, 0, self.scale, self.scale)
    Map:draw(-Camera.x, -Camera.y, self.scale, self.scale)
    Camera:apply()
    Player:draw()
    Fire.drawAll()
    Blackhole.drawAll()
    Camera:clear()
    GUI:draw()
end

function game:keypressed(key)
    Player:keyboardInput(key)
    if key == "r" then
        print("LOADING")
        game.setScene("loading")
    end
end
function game:gamepadpressed(joystick, button)
    isMobile = false
    Player:gamepadInput(button)
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
return game
