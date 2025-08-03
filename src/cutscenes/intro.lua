local intro = {
    scenes = {},
    sceneTexts = {"Long ago, the gods danced in basking glory", "They shaped the worlds with light, laughter... and law",
                  "But from their order... came envy", "Null was born, the end... with no beginning",
                  "The war was historic, the gods fought... and fell", "And from their ashes, one spark remained",
                  "Orbis, the last light! The only hope left.", "Escape the Void. Reach the Core. Don't fight it, RUN!"},
    currentIndex = 1,
    timer = 0,
    fadeTimer = 0
}

function intro:load()

    for i = 1, 8 do
        self.scenes[i] = love.graphics.newImage("assets/vfx/cutscenes/frame" .. i .. ".png")
    end
end

function intro:update(dt)
    self.timer = self.timer + dt
    if self.fadeTimer < .6 then
        self.fadeTimer = self.fadeTimer + (0.2 * dt)
    end
end

function intro:draw()
    love.graphics.setColor(1, 1, 1, self.fadeTimer)
    if self.scenes[self.currentIndex] then
        love.graphics.draw(self.scenes[self.currentIndex], 0, 0)
    end

    -- Draw text
    local text = self.sceneTexts[self.currentIndex]
    local textWidth = paragraph:getWidth(text)
    local textHeight = paragraph:getHeight()

    love.graphics.setFont(paragraph)

    love.graphics.setColor(0, 0, 0, self.fadeTimer)
    love.graphics.print(text, ((wW - textWidth) / 2) + 4,( wH - textHeight - 30))
    love.graphics.print(text, ((wW - textWidth) / 2),( wH - textHeight - 30) + 4)
    love.graphics.print(text, ((wW - textWidth) / 2) - 4,( wH - textHeight - 30))
    love.graphics.print(text, ((wW - textWidth) / 2),( wH - textHeight - 30) - 4)

    love.graphics.setColor(1, 1, 1, self.fadeTimer)
    love.graphics.print(text, (wW - textWidth) / 2, wH - textHeight - 30)
end

function intro:keypressed(key)
    if key == "return" then
        self:inputReceived()
    end
end

function intro:touchpressed(id, x, y)
    self:inputReceived()
end

function intro:mousepressed(x, y, button)
    self:inputReceived()
end

function intro:inputReceived()
    if self.currentIndex < #self.sceneTexts then
        self.currentIndex = self.currentIndex + 1
        self.timer = 0
        self.fadeTimer = 0
    else
        -- Transition to next game state here
        print("End of intro")
    end
end
return intro
