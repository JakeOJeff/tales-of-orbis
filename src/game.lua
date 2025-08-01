local game = {}
local STI = require("src.libs.sti")

-- REQUIRE CLASSES
require("src.classes.player")

-- Input Connections 
joysticks = love.joystick.getJoysticks( )
Joystick = joysticks[1] or nil
jAxes = {}
if Joystick then
    jAxes[1], jAxes[2], jAxes[3], jAxes[4] = Joystick:getAxes() -- lH, lV, rH, rV
end

function game:load()
    Map = STI("assets/map/1.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    Map:box2d_init(World)
    Map.layers.solid.visible = false

    Player:load()
end

function game:update(dt)

    World:update(dt)
    Player:update(dt)

end

function game:draw()
    Map:draw(0, 0, 2, 2)
    love.graphics.push()
    love.graphics.scale(2, 2)

    Player:draw()
    love.graphics.pop()

end

function game:keypressed(key)
    if key == "r" then
        print("LOADING")
        game.setScene("loading")
    end
end
return game
