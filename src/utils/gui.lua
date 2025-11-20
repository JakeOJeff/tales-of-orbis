GUI = {}
require("src.classes.textbox")

function GUI:load()
    local navW, navH = 100 * scale, 100 * scale -- left, right, jump 
    local velW, velH = 70 * scale, 70 * scale -- boost, dive, 
    local setW, setH = 85 * scale, 80 * scale -- reset, pause


    self.buttons = {}
    self.buttons.leftButton = self:createButton("assets/vfx/icons/left.png", 50 * scale, wH - navH - (50 * scale), navW, navH )
    self.buttons.rightButton = self:createButton("assets/vfx/icons/right.png", navW + (50 + 10) * scale, wH - navH - (50 * scale), navW, navH )
    self.buttons.jumpButton = self:createButton("assets/vfx/icons/jump.png", wW - navW - 100 * scale, wH - navH - 150 * scale, navW, navH)

    self.buttons.diveButton = self:createButton("assets/vfx/icons/dive.png", wW - velW - (50 * scale), wH - velH - (70 * scale), velW, velH, function ()
        return not Player.grounded
    end)
    self.buttons.boostButton = self:createButton("assets/vfx/icons/boost.png", wW - (velW * 2) - (100 * scale), wH - velH - (50 * scale), velW, velH)
    
    self.buttons.resetButton = self:createButton("assets/vfx/icons/reset.png", wW - setW*2 - 30 * scale, 20 * scale, setW, setH)
    self.buttons.pauseButton = self:createButton("assets/vfx/icons/pause.png", wW - setW - 20 * scale, 20 * scale, setW, setH)

    self.hudS = {src = love.graphics.newImage("assets/vfx/icons/hudsquare.png"), x = 20 * scale, y = 20 * scale, w = 300/2.5 * scale, h = 300/2.5 * scale}
    self.hudB = {src = love.graphics.newImage("assets/vfx/icons/hudbars.png"), x = 20 * scale + self.hudS.w, y = 20 * scale, w = 790/2.5 * scale, h = 190/2.5 * scale}
    self.hudC = {src = love.graphics.newImage("assets/vfx/icons/hudcounter.png"), x = 20 * scale + self.hudS.w, y = 20 * scale + self.hudB.h, w = 110/2.5 * scale, h = 110/2.5 * scale}
    self.relicsDisplay = { src = love.graphics.newImage("assets/vfx/items/relic.png"), x = self.hudS.x + (self.hudS.w / 4) , y = self.hudS.y + (self.hudS.h / 4), w = (self.hudS.w / 2), h = (self.hudS.h / 2), alpha = 0.6 }
        self.relicsDisplay.baseY = self.relicsDisplay.y

    Textbox:clear()
    self.msg = Textbox:new("Reached Checkpoint", wW/2 - 150, 200, 0, 300, 60)
    
    self.touches = love.touch.getTouches()
end

function GUI:update(dt)
    self.touches = love.touch.getTouches()
    -- Animations
    self.relicsDisplay.y = self.relicsDisplay.baseY + math.sin(game.time * 2) * 5
    -- Setting all holding to false
    for _, v in pairs(self.buttons) do
        v.holding = false   
    end
    -- Check each touch
    for _, id in pairs(self.touches) do
        local x, y = love.touch.getPosition(id)
        for _, v in pairs(self.buttons) do
            if distRect(x, y, v.x, v.y, v.w, v.h) and v.cond() then
                v.holding = true
                v.holdTime = (v.holdTime or 0) + dt
            else
                v.holdTime = 0
            end
        end
    end

    Textbox.updateAll(dt)
end

function GUI:draw()
    if not paused then
        local b = self.buttons
        if IsMobile then
            self:drawButton(b.leftButton,20)
            self:drawButton(b.rightButton,20)
            self:drawButton(b.jumpButton,80)

            self:drawButton(b.diveButton,100)
            self:drawButton(b.boostButton,100)
        end
        self:drawButton(b.resetButton,20)
        self:drawButton(b.pauseButton,20)

        -- Boost and Health Bar
        LG.setColor(0.79, 0.50, 0.19)
        LG.rectangle("fill", self.hudB.x, self.hudB.y + self.hudB.h/2, self.hudB.w * math.min(Player.health.current / Player.health.max, 1), self.hudB.h/2, 10, 10)
        LG.setColor(0.56, 0.23, 0.11)
        LG.rectangle("fill", self.hudB.x, self.hudB.y, self.hudB.w * math.min(Player.boost / Player.maxBoost, 1), self.hudB.h/2, 10, 10)

        LG.setColor(1, 1, 1, self.relicsDisplay.alpha)
        self:drawNormalizedImage(self.relicsDisplay)
        LG.setColor(1,1,1,1)
        LG.setFont(paragraph)   
        LG.print(Player.collectedRelics, self.hudS.x + self.hudS.w/2 - paragraph:getWidth(Player.collectedRelics)/2, self.hudS.y + self.hudS.h/2 - paragraph:getHeight()/2)
        LG.setFont(tag)
        local tTimer = math.abs(math.floor(Player.torchTimer))
        local tTimerString = math.floor(tTimer/60).. ":"..tTimer%60
        LG.print(tTimerString, self.hudC.x + self.hudC.w/2 - tag:getWidth(tTimerString)/2 + 2 * scale, self.hudC.y + self.hudC.h/2 - tag:getHeight()/2 + 2 * scale)
        self:drawNormalizedImage(self.hudS)
        self:drawNormalizedImage(self.hudB)
        self:drawNormalizedImage(self.hudC)


        Textbox.drawAll()
    end

end

function GUI:createButton(src, x, y, w, h, cond)
    local table = {}
    table.x = x
    table.y = y
    table.w = w or (50  * scale)
    table.h = h or (50 * scale)
    table.src = LG.newImage(src)
    table.cond = cond or function ()
        return true
    end
    table.holding = false
    table.holdTime = 0

    return table
end

function GUI:drawButton(v, round)
    if v.cond() then
        LG.setColor(0, 0, 0, 0.6)
        if v.holding then
            LG.setColor(0.1, 0.1, 0.1, 0.6)
        end
        LG.rectangle("fill", v.x, v.y, v.w, v.h, round, round)
        LG.setColor(1, 1, 1)
        self:drawNormalizedImage(v)
    end
end
function GUI:drawNormalizedImage(v)
    local img = v.src
    local iw, ih = img:getWidth(), img:getHeight()
    local scale = math.min(v.w / iw, v.h / ih)
    local dx = v.x + (v.w - iw * scale) / 2
    local dy = v.y + (v.h - ih * scale) / 2
    love.graphics.draw(img, dx, dy, 0, scale, scale)
end