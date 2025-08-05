GUI = {}

function GUI:load()
    local buttonW = 130 * scale
    local buttonH = 130 * scale
    local jumpW = 80 * scale
    local jumpH = 80 * scale

    self.leftButton = {
        x = 100 * scale,
        y = wH - buttonH - 75 * scale, -- 40 is padding from bottom
        w = buttonW,
        h = buttonH,
        holding = false
    }

    self.rightButton = {
        x = (100 + 130 + 10) * scale, -- 80 initial + 110 spacing
        y = wH - buttonH - 75 * scale,
        w = buttonW,
        h = buttonH,
        holding = false
    }

    self.jumpButton = {
        x = wW - jumpW - 90 * scale, -- 80 is right-side padding
        y = wH - jumpH - 160 * scale, -- padding from bottom
        w = jumpW,
        h = jumpH
    }
end

function GUI:update(dt)
    local mx, my = love.mouse.getPosition()
    local lB = self.leftButton
    local rB = self.rightButton

    lB.holding = love.mouse.isDown(1) and distRect(mx, my, lB.x, lB.y, lB.w, lB.h)
    rB.holding = love.mouse.isDown(1) and distRect(mx, my, rB.x, rB.y, rB.w, rB.h)

end

function GUI:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 10, love.graphics.getHeight() / 2 - 50, 20, 100, 10, 10)
    love.graphics.setColor(0.56, 0.23, 0.11)
    love.graphics.rectangle("fill", 10, love.graphics.getHeight() / 2 - 50, 20,
        100 * math.max((Player.boost / Player.maxBoost), 0), 10, 10)
    print("YES")
    love.graphics.setColor(1, 1, 1)

    if isMobile then
        love.graphics.setColor(0, 0, 0, 0.6)
        local lB = self.leftButton
        local rB = self.rightButton
        local jB = self.jumpButton
        if lB.holding then
            love.graphics.setColor(0.1, 0.1, 0.1, 0.6)
        end
        love.graphics.rectangle("fill", lB.x, lB.y, lB.w, lB.h, 10, 10)
        love.graphics.setColor(0, 0, 0, 0.6)
        if rB.holding then
            love.graphics.setColor(0.1, 0.1, 0.1, 0.6)
        end
        love.graphics.rectangle("fill", rB.x, rB.y, rB.w, rB.h, 10, 10)
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", jB.x, jB.y, jB.w, jB.h, 40, 40)
        love.graphics.setColor(1, 1, 1)

    end

end
