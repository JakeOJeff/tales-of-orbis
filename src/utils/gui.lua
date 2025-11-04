GUI = {}

function GUI:load()
    self.buttons = {}

    self:createButton("")

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


    end
end

function GUI:createButton(src, x, y, cond)
    local table = {}
    table.x = x * scale
    table.y = y * scale
    table.src = love.graphics.newImage(src)
    table.cond = cond or nil -- func()
    table.holding = false
    table.holdTime = 0

    return table
end
