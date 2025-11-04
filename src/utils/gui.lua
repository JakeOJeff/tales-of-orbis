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
        self:drawButton()
    end
end

function GUI:createButton(src, x, y, cond)
    local table = {}
    table.x = x * scale
    table.y = y * scale
    table.src = LG.newImage(src)
    table.cond = cond or function ()
        return true
    end
    table.holding = false
    table.holdTime = 0

    return table
end

function GUI:drawButton(v, size, round)
    if v.holding then
        LG.setColor(0.1, 0.1, 0.1, 0.6)
    end
    local w, h = v.img:getWidth() * size * scale, v.img:getHeight() * size  * scale
    LG.rectangle("fill", v.x, v.y, w, h, round, round)
    LG.setColor(1, 1, 1)
    LG.draw(v.src, v.x + w/2 + (v.img:getWidth()/2 * scale), v.y + h/2 + (v.img:getHeight()/2 * scale), 0, scale, scale)
    LG.setColor(0, 0, 0, 0.6)
end
