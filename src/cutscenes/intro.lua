local intro = {
    scenes = {

    },
    sceneTexts = {
        "Long ago, the gods danced among the stars",
        "They shaped the worlds with light, laughter... and law",
        "But from their order... came envy",
        "Null was born, the end... with no beginning",
        "The war was historic, the gods fought... and fell",
        "And from their ashes, one spark remained",
        "Orbis, the last light! The only hope left.",
        "Escape the Void. Reach the Core. Don't fight it, RUN!"
    
    },
    currentIndex = 1,
    textPos = {
        {20, 20},
        {20, wH - subheading:getHeight() - 20},
        {wW - subheading:getWidth("") - 20, 20},
        {wW - subheading:getWidth("") - 20, wH - subheading:getHeight() - 20}
    },
    timer = 0,
    fadeTimer = 0,
}

function intro:load()
    for i = 1, 8 do
        self.scenes = love.graphics.newImage("frame"..i..".png")
    end
end

function intro:update(dt)
    self.textPos = {
        {20, 20},
        {20, wH - subheading:getHeight() - 20},
        {wW - subheading:getWidth(self.sceneTexts[self.currentIndex]) - 20, 20},
        {wW - subheading:getWidth(self.sceneTexts[self.currentIndex]) - 20, wH - subheading:getHeight() - 20}
    }
end

function intro:draw()

end

return intro