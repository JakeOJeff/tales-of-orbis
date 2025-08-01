
local game = {}
local STI = require("src.libs.sti")

function game:load()
    Map = STI("assets/map/1.lua", {"box2d"})
end

function game:update(dt)

end

function game:draw()
    Map:draw(0, 0, 2, 2)
    love.graphics.push()
    love.graphics.scale(2, 2)
    love.graphics.pop()

end

function game:keypressed(key)
    if key == "r" then
        print("LOADING")
        game.setScene("loading")
    end
end
return game