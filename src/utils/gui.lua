GUI = {}

function GUI:load()
    self.leftButton ={
        x = 80,
        y = love.graphics.getHeight() - 160,
        w = 100,
        h = 100
    }
    self.rightButton ={
        x = 190,
        y = love.graphics.getHeight() - 160,
        w = 100,
        h = 100
    }
    self.jumpButton = {
        x = love.graphics.getWidth() - 200,
        y = love.graphics.getHeight() - 160,
        w = 80,
        h = 80

    }
end

function GUI:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 10, love.graphics.getHeight() / 2 - 50, 20, 100, 10, 10)
    love.graphics.setColor(0.56, 0.23, 0.11)
    love.graphics.rectangle("fill", 10, love.graphics.getHeight() / 2 - 50, 20,
        100 * math.max((Player.boost / Player.maxBoost), 0), 10, 10)
    print("YES")
    love.graphics.setColor(1, 1, 1)

    if not isMobile then
        love.graphics.setColor(0, 0, 0, 0.6)
        local lB = self.leftButton
        local rB = self.rightButton
        love.graphics.rectangle("fill", lB.x, lB.y , lB.w, lB.h, 10, 10)
        love.graphics.rectangle("fill", rB.x, rB.y, rB.w, rB.h, 10, 10)

       love.graphics.rectangle("fill", love.graphics.getWidth() - 200, love.graphics.getHeight() - 160, 20, 20, 10, 10)
        love.graphics.setColor(1, 1, 1)

    end

end
