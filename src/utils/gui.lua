GUI = {}

function GUI:load()
    self.buttons = {}
    self.buttons.leftButton = self:createButton("assets/vfx/icons/left.png", 20, wH - 20 )
    self.buttons.rightButton = self:createButton("assets/vfx/icons/right.png", 20 + 10 + self.buttons.leftButton.src:getWidth(), wH - 20 )
    self.buttons.boostButton = self:createButton("assets/vfx/icons/boost.png", 50, 50)
    self.buttons.jumpButton = self:createButton("assets/vfx/icons/jump.png", 100, 100)
    self.buttons.resetButton = self:createButton("assets/vfx/icons/reset.png", wW - 100, 20)
    self.buttons.pauseButton = self:createButton("assets/vfx/icons/pause.png", wW - 200, 20)
    self.buttons.diveButton = self:createButton("assets/vfx/icons/dive.png", wW - 20, wH - 30)

    self.touches = love.touch.getTouches()
end

function GUI:update(dt)
    self.touches = love.touch.getTouches()
    -- Check each touch
    for _, id in pairs(self.touches) do
        local x, y = love.touch.getPosition(id)
        for _, v in pairs(self.buttons) do
            if distRect(x, y, v.x, v.y, v.w, v.h) and v.cond() then
                v.holding = true
                v.holdTime = (v.holdTime or 0) + dt
            end
        end
    end
end

function GUI:draw()

    if IsMobile and not paused then

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
    table.cond = cond or function ()
        return true
    end
    table.holding = false
    table.holdTime = 0

    return table
end

function GUI:drawButton(size, round)


end
