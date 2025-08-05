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
        img = {
            x = 0,
            y = 0,
            w = buttonW / scale,
            h = buttonH / scale,
            src = love.graphics.newImage("assets/vfx/icons/left.png")
        },
        holding = false
    }

    self.rightButton = {
        x = (100 + 130 + 10) * scale, -- 80 initial + 110 spacing
        y = wH - buttonH - 75 * scale,
        w = buttonW,
        h = buttonH,
        img = {
            x = 0,
            y = 0,
            w = buttonW / scale,
            h = buttonH / scale,
            src = love.graphics.newImage("assets/vfx/icons/right.png")
        },
        holding = false
    }

    self.jumpButton = {
        x = wW - jumpW - 90 * scale, -- 80 is right-side padding
        y = wH - jumpH - 190 * scale, -- padding from bottom
        w = jumpW,
        h = jumpH,
        img = {
            x = 0,
            y = 0,
            w = buttonW / scale,
            h = buttonH / scale,
            src = love.graphics.newImage("assets/vfx/icons/jump.png")
        }
    }

    self.boostButton = {
        x = wW - jumpW - 190 * scale, -- 80 is right-side padding
        y = wH - jumpH - 90 * scale, -- padding from bottom
        w = jumpW,
        h = jumpH,
        holding = false
    }

    self.leftButton.img.x = self.leftButton.x + self.leftButton.w / 2 - self.leftButton.img.w / 2
    self.leftButton.img.y = self.leftButton.y + self.leftButton.h / 2 - self.leftButton.img.h / 2
    self.rightButton.img.x = self.rightButton.x + self.rightButton.w / 2 - self.rightButton.img.w / 2
    self.rightButton.img.y = self.rightButton.y + self.rightButton.h / 2 - self.rightButton.img.h / 2
    self.jumpButton.img.x = self.jumpButton.x + self.jumpButton.w / 2 - self.jumpButton.img.w / 2
    self.jumpButton.img.y = self.jumpButton.y + self.jumpButton.h / 2 - self.jumpButton.img.h / 2
end

function GUI:update(dt)
    local mx, my = love.mouse.getPosition()
    local lB = self.leftButton
    local rB = self.rightButton
    local bB = self.boostButton

    lB.holding = love.mouse.isDown(1) and distRect(mx, my, lB.x, lB.y, lB.w, lB.h)
    rB.holding = love.mouse.isDown(1) and distRect(mx, my, rB.x, rB.y, rB.w, rB.h)
    bB.holding = love.mouse.isDown(1) and distRect(mx, my, bB.x, bB.y, bB.w, bB.h)
end

function GUI:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", wW - 60 * scale, love.graphics.getHeight() / 2 - (200 * scale) / 2, 40 * scale,
        200 * scale, 10 * scale, 10 * scale)
    love.graphics.setColor(0.56, 0.23, 0.11)
    love.graphics.rectangle("fill", wW - 60 * scale, love.graphics.getHeight() / 2 - (200 * scale) / 2, 40 * scale,
        200 * scale * math.max((Player.boost / Player.maxBoost), 0), 10, 10)
    print("YES")
    love.graphics.setColor(1, 1, 1)

    if not isMobile then
        love.graphics.setColor(0, 0, 0, 0.6)
        local lB = self.leftButton
        local rB = self.rightButton
        local jB = self.jumpButton
        local bB = self.boostButton
        if lB.holding then
            love.graphics.setColor(0.1, 0.1, 0.1, 0.6)
        end
        love.graphics.rectangle("fill", lB.x, lB.y, lB.w, lB.h, 10, 10)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.leftButton.img.src, lB.img.x, lB.img.y, 0, lB.img.w, lB.img.h)
        love.graphics.setColor(0, 0, 0, 0.6)
        if rB.holding then
            love.graphics.setColor(0.1, 0.1, 0.1, 0.6)
        end
        love.graphics.rectangle("fill", rB.x, rB.y, rB.w, rB.h, 10, 10)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.rightButton.img.src, rB.img.x, rB.img.y, 0, rB.img.w, rB.img.h)
        love.graphics.setColor(0, 0, 0, 0.6)
        if bB.holding then
            love.graphics.setColor(0.1, 0.1, 0.1, 0.6)
        end
        love.graphics.rectangle("fill", bB.x, bB.y, bB.w, bB.h, 40, 40)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.jumpButton.img.src, jB.img.x, jB.img.y, 0, jB.img.w, jB.img.h)
        love.graphics.setColor(0, 0, 0, 0.6)

        love.graphics.rectangle("fill", jB.x, jB.y, jB.w, jB.h, 40, 40)
        love.graphics.setColor(1, 1, 1)

    end

end
