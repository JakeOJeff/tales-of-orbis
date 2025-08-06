GUI = {}

function GUI:load()
    local buttonW = 130 * scale
    local buttonH = 130 * scale
    local imgW = love.graphics.newImage("assets/vfx/icons/left.png"):getWidth()
    local jumpW = 80 * scale
    local jumpH = 80 * scale


    self.touches = love.touch.getTouches()
    self.leftButton = {
        x = 100 * scale,
        y = wH - buttonH - 75 * scale, -- 40 is padding from bottom
        w = buttonW,
        h = buttonH,
        img = {
            x = 0,
            y = 0,
            w = imgW / scale,
            h = imgW / scale,
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
            w = imgW / scale,
            h = imgW / scale,
            src = love.graphics.newImage("assets/vfx/icons/right.png")
        },
        holding = false
    }

    self.boostButton = {
        x = wW - jumpW - 190 * scale, -- 80 is right-side padding
        y = wH - jumpH - 90 * scale, -- padding from bottom
        w = jumpW,
        h = jumpH,
        img = {
            x = 0,
            y = 0,
            w = imgW / scale,
            h = imgW / scale,
            src = love.graphics.newImage("assets/vfx/icons/boost.png")
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
            w = imgW / scale,
            h = imgW / scale,
            src = love.graphics.newImage("assets/vfx/icons/jump.png")
        },
        holding = false
    }

end

function GUI:update(dt)
    local lB = self.leftButton
    local rB = self.rightButton
    local bB = self.boostButton
    local jB = self.jumpButton

    -- Reset all holding states
    lB.holding = false
    rB.holding = false
    bB.holding = false
    jB.holding = false

    self.touches = love.touch.getTouches()
    -- Check each touch
    for _, id in pairs(self.touches) do
        local x, y = love.touch.getPosition(id)
        if distRect(x, y, lB.x, lB.y, lB.w, lB.h) then
            lB.holding = true
        end
        if distRect(x, y, rB.x, rB.y, rB.w, rB.h) then
            rB.holding = true
        end
        if distRect(x, y, bB.x, bB.y, bB.w, bB.h) then
            bB.holding = true
        end
        if distRect(x, y, jB.x, jB.y, jB.w, jB.h) then
            jB.holding = true
        end
    end

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

    if isMobile then
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
        self:drawButtonImage(lB)
        love.graphics.setColor(0, 0, 0, 0.6)

        if rB.holding then
            love.graphics.setColor(0.1, 0.1, 0.1, 0.6)
        end
        love.graphics.rectangle("fill", rB.x, rB.y, rB.w, rB.h, 10, 10)
        love.graphics.setColor(1, 1, 1)
        self:drawButtonImage(rB)
        love.graphics.setColor(0, 0, 0, 0.6)

        if bB.holding then
            love.graphics.setColor(0.1, 0.1, 0.1, 0.6)
        end
        love.graphics.rectangle("fill", bB.x, bB.y, bB.w, bB.h, 40, 40)
        love.graphics.setColor(1, 1, 1)
        self:drawButtonImage(bB)
        love.graphics.setColor(0, 0, 0, 0.6)

        if jB.holding then
            love.graphics.setColor(0.1, 0.1, 0.1, 0.6)
        end
        love.graphics.rectangle("fill", jB.x, jB.y, jB.w, jB.h, 40, 40)
        love.graphics.setColor(1, 1, 1)
        self:drawButtonImage(jB)
        love.graphics.setColor(0, 0, 0, 0.6)

        love.graphics.setColor(1, 1, 1)

    end

end
function GUI:drawButtonImage(button)
    local img = button.img.src
    local iw, ih = img:getWidth(), img:getHeight()
    local scale = math.min(button.w / iw, button.h / ih)
    local dx = button.x + (button.w - iw * scale) / 2
    local dy = button.y + (button.h - ih * scale) / 2
    love.graphics.draw(img, dx, dy, 0, scale, scale)
end
