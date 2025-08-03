GUI = {}

function GUI:load()

end

function GUI:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 10, love.graphics.getHeight()/2 - 50,20, 100, 10, 10)
    love.graphics.setColor(0.56, 0.23, 0.11)
    love.graphics.rectangle("fill", 10, love.graphics.getHeight()/2 - 50,20, 100 * math.max((Player.boost / Player.maxBoost), 0), 10, 10)
    print("YES")
    love.graphics.setColor(1, 1, 1)

end
