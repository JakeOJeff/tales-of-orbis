local a1s1 = {
    scenes = {},
    sceneTexts = { "Why have you come so far?",
        "For the truth lies in the way you were born", "To be Continued..."
    },
    currentIndex = 1,
    timer = 0,
    fadeTimer = 0
}

function a1s1:load()
    for i = 1, #self.sceneTexts do
        self.scenes[i] = LG.newImage("assets/vfx/cutscenes/act1scene1/frame" .. i .. ".png")
    end
end

function a1s1:update(dt)
    self.timer = self.timer + dt
    if self.fadeTimer < 1 then
        self.fadeTimer = self.fadeTimer + (.5 * dt)
    end
end

function a1s1:draw()
    LG.setColor(1, 1, 1, self.fadeTimer)
    if self.scenes[self.currentIndex] then
        LG.push()
        -- Use the minimum scale that fits the full base resolution in screen
        print(scale, wW, baseW)
        LG.scale(scale, scale)
        LG.draw(self.scenes[self.currentIndex], cenW, cenH)
        LG.pop()
    end

    -- Draw text
    local text = self.sceneTexts[self.currentIndex]
    local textWidth = paragraph:getWidth(text)
    local textHeight = paragraph:getHeight()

    LG.setFont(paragraph)

    LG.setColor(0, 0, 0, (self.fadeTimer / 0.6))
    LG.print(text, ((wW - textWidth) / 2) + 4, (wH - textHeight - 50))
    LG.print(text, ((wW - textWidth) / 2), (wH - textHeight - 50) + 4)
    LG.print(text, ((wW - textWidth) / 2) - 4, (wH - textHeight - 50))
    LG.print(text, ((wW - textWidth) / 2), (wH - textHeight - 50) - 4)

    LG.setColor(1, 1, 1, (self.fadeTimer / 0.6))
    LG.print(text, (wW - textWidth) / 2, wH - textHeight - 50)
end

function a1s1:keypressed(key)
    self:inputReceived()
end

function a1s1:gamepadpressed(joystic, button)
    self:inputReceived()
end

-- function intro:touchpressed(id, x, y)
--     self:inputReceived()
-- end

-- Using mouse input for phone as well
function a1s1:mousepressed(x, y, button)
    self:inputReceived()
end

function a1s1:inputReceived()
    if self.currentIndex < #self.sceneTexts then
        self.currentIndex = self.currentIndex + 1
        self.timer = 0
        self.fadeTimer = 0
    else
        a1s1.setScene("game")
    end
end

return a1s1
