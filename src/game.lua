
local game = {}

function game:load()

end

function game:update(dt)

end

function game:draw()

end

function game:keypressed(key)
    if key == "r" then
        print("LOADING")
        game.setScene("loading")
    end
end
return game