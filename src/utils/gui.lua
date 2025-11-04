GUI = {}

function GUI:load()
    
    self.touches = love.touch.getTouches()

end

function GUI:update(dt)
    local lB = self.leftButton
    local rB = self.rightButton
    local bB = self.boostButton
    local jB = self.jumpButton
    local rtB = self.resetButton
    local pB = self.pauseButton
    local rsB = self.resumeButton
    local dB = self.diveButton

    -- Reset all holding states
    lB.holding = false
    rB.holding = false
    bB.holding = false
    jB.holding = false
    rtB.holding = false
    pB.holding = false
    rsB.holding = false
    dB.holding = false


    if jB.holdTime and jB.holdTime > 0 then
        jB.holdTime = 0 -- Reset hold time after jump
    end

    self.relicsDisplay.scaleX = math.sin(5 + love.timer.getTime() * 2)

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
            jB.holdTime = (jB.holdTime or 0) + dt
        end
        if distRect(x, y, dB.x, dB.y, dB.w, dB.h) and not Player.grounded then
            dB.holding = true
        end
    end
    if distRect(love.mouse.getX(), love.mouse.getY(), rsB.x, rsB.y, rsB.w, rsB.h) then
        rsB.holding = true
    end
end

function GUI:draw()

    if IsMobile and not paused then
        love.graphics.setColor(0, 0, 0, 0.6)
        local lB = self.leftButton
        local rB = self.rightButton
        local jB = self.jumpButton
        local bB = self.boostButton
        local dB = self.diveButton

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

        if not Player.grounded  then
            if dB.holding then
                love.graphics.setColor(0.1, 0.1, 0.1, 0.6)
            end
            love.graphics.rectangle("fill", dB.x, dB.y, dB.w, dB.h, 40, 40)
            love.graphics.setColor(1, 1, 1)
            self:drawButtonImage(dB)
            love.graphics.setColor(0, 0, 0, 0.6)
        end

        love.graphics.setColor(1, 1, 1)
    end

    if paused then
        local pauseText = "Paused"
        love.graphics.setColor(1, 1, 1, 0.8)
        love.graphics.setFont(heading)
        love.graphics.print(pauseText, wW / 2 - heading:getWidth(pauseText) / 2, wH / 2 - heading:getHeight() / 2)
    else
        local rtB = self.resetButton
        local pB = self.pauseButton

        local rD = self.relicsDisplay


        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", rtB.x, rtB.y, rtB.w, rtB.h, 10, 10)
        love.graphics.setColor(1, 1, 1)
        self:drawButtonImage(rtB)

        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", pB.x, pB.y, pB.w, pB.h, 10, 10)
        love.graphics.setColor(1, 1, 1)
        self:drawButtonImage(pB)


        -- Boost Bar
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", wW - 60 * scale, love.graphics.getHeight() / 2 - (200 * scale) / 2, 20 * scale,
            200 * scale, 5 * scale, 5 * scale)
        love.graphics.setColor(0.56, 0.23, 0.11)
        love.graphics.rectangle("fill", wW - 60 * scale, love.graphics.getHeight() / 2 - (200 * scale) / 2, 20 * scale,
            200 * scale * math.max((Player.boost / Player.maxBoost), 0), 5, 5)
        -- Health Bar
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", wW - 85 * scale, love.graphics.getHeight() / 2 - (200 * scale) / 2, 20 * scale,
            200 * scale, 5 * scale, 5 * scale)
        love.graphics.setColor(0.79, 0.50, 0.19)
        love.graphics.rectangle("fill", wW - 85 * scale, love.graphics.getHeight() / 2 - (200 * scale) / 2, 20 * scale,
            200 * scale * math.max((Player.health.current / Player.health.max), 0), 5, 5)
        love.graphics.setColor(1, 1, 1)

        -- Relics Display
        love.graphics.setFont(paragraph)
       self:drawButtonImage(rD, self.relicsDisplay.scaleX)
       love.graphics.setColor(1, 1, 1)
       love.graphics.print(Player.collectedRelics, rD.x + (rD.w - rD.img.src:getWidth() * scale) + 20 * scale, rD.y + (rD.h - rD.img.src:getHeight() - paragraph:getHeight()/2 * scale)/2 + 10 * scale)



        love.graphics.setColor(0.56, 0.23, 0.11)
        love.graphics.rectangle("fill", 30 + (290 * 0.4) * scale, 30 * scale, (800 * 0.4) * math.max((Player.boost / Player.maxBoost), 0) * scale, 80 * 0.4 * scale , 10, 10)

        local hudS = self.hud
        love.graphics.draw(hudS.src, hudS.x, hudS.y, 0, hudS.w, hudS.h)
    end
end

-- function GUI:drawButtonImage(button, sX)
--     local img = button.img.src
--     local iw, ih = img:getWidth(), img:getHeight()
--     local scale = math.min(button.w / iw, button.h / ih)
--     local scaleX = sX or scale
--     local dx = button.x + (button.w - iw * scale) / 2
--     local dy = button.y + (button.h - ih * scale) / 2
--     love.graphics.draw(img, dx, dy + scaleX, 0, scale, scale)
-- end
