local intro = {
    scenes = {},
    sceneTexts = { "Why have you come so far?",
        "For the truth lies in the way you were born", "To be Continued..."
    },
    currentIndex = 1,
    timer = 0,
    fadeTimer = 0
}

function intro:load()
    for i = 1, 7 do
        self.scenes[i] = love.graphics.newImage("assets/vfx/cutscenes/act1scene1/frame" .. i .. ".png")
    end
end

function intro:update(dt)
    self.timer = self.timer + dt
    if self.fadeTimer < 1 then
        self.fadeTimer = self.fadeTimer + (.5 * dt)
    end
end

function intro:draw()
    love.graphics.setColor(1, 1, 1, self.fadeTimer)
    if self.scenes[self.currentIndex] then
        love.graphics.push()
        love.graphics.scale(scale, scale)
        love.graphics.draw(self.scenes[self.currentIndex], cenW, cenH)
        love.graphics.pop()
    end

    -- Draw text
    local text = self.sceneTexts[self.currentIndex]
    local textWidth = paragraph:getWidth(text)
    local textHeight = paragraph:getHeight()

    love.graphics.setFont(paragraph)

    love.graphics.setColor(0, 0, 0, (self.fadeTimer / 0.6))
    love.graphics.print(text, ((wW - textWidth) / 2) + 4, (wH - textHeight - 50))
    love.graphics.print(text, ((wW - textWidth) / 2), (wH - textHeight - 50) + 4)
    love.graphics.print(text, ((wW - textWidth) / 2) - 4, (wH - textHeight - 50))
    love.graphics.print(text, ((wW - textWidth) / 2), (wH - textHeight - 50) - 4)

    love.graphics.setColor(1, 1, 1, (self.fadeTimer / 0.6))
    love.graphics.print(text, (wW - textWidth) / 2, wH - textHeight - 50)
end

function intro:keypressed(key)
    self:inputReceived()
end

function intro:gamepadpressed(joystic, button)
    isMobile = false
    self:inputReceived()
end

-- function intro:touchpressed(id, x, y)
--     self:inputReceived()
-- end

-- Using mouse input for phone as well
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
        introTrack:stop()
        intro.setScene("game")
    end
end

return intro
