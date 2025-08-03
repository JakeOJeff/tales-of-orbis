local game = {
    background = love.graphics.newImage("assets/vfx/loading/background.png")
}
local STI = require("src.libs.sti")
-- REQUIRE LIBRARIES
anim8 = require 'src.libs.anim8'
-- REQUIRE CLASSES
require("src.classes.player")

-- REQUIRE UTILS
local utils = {}
utils.collisions = require("src.utils.collisions")

-- Input Connections 
joysticks = love.joystick.getJoysticks()
Joystick = joysticks[1] or nil
jAxes = {0, 0, 0, 0}

function game:load()
    Map = STI("assets/map/1.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false

    Player:load()
end

function game:update(dt)
    if Joystick then
        jAxes[1], jAxes[2], jAxes[3], jAxes[4] = Joystick:getAxes() -- lH, lV, rH, rV
    end
    World:update(dt)
    Player:update(dt)

end

function game:draw()
    love.graphics.draw(self.background, 0, 0)
    Map:draw(0, 0, 3, 3)
    love.graphics.push()
    love.graphics.scale(3, 3)

    Player:draw()
    love.graphics.pop()

end

function game:keypressed(key)
    Player:keyboardInput(key)
    if key == "r" then
        print("LOADING")
        game.setScene("loading")
    end
end
function game:gamepadpressed(joystick, button)
    Player:gamepadInput(button)
end
function beginContact(a, b, collision)
    utils.collisions:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    utils.collisions:endContact(a, b, collision)

end
return game
