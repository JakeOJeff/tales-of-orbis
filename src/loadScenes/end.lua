local endScene = {
    text = {
        "Directed and produced by JakeOJeff",
        "I crode a lot making this",
        "Game is entirely built using the LOVE2D Frameworks",
        "Artwork and assets were clogged and made by me :(",
        "I refactored the code TWICE [ TWICE man TWOICE ]",
        "I might refactor it again ehehe",
        "I don't really know what to do",
        "Wait for the next part, I guess :D"
    }
}


function endScene:load()
    self.index = 1
    self.time = 0
    self.timeInterval = 2

    self.pos = {
        x = 0,
        y = 0
    }
    
end

function endScene:update(dt)
    self.time = self.time + dt

    if self.time > self.timeInterval then
        self.time = 0
        if self.index < #self.text then
            self.index = self.index + 1
        end
    end
    self.pos.x = wW/2 - paragraph:getWidth(self.text[self.index])/2

    self.pos.y = (wH / 2 + paragraph:getHeight()/2 + 40) - 40 * self.time/self.timeInterval
end

function endScene:draw()
    love.graphics.setFont(paragraph)
    love.graphics.setColor(1,1,1,self.time/self.timeInterval)
    love.graphics.print(self.text[self.index], self.pos.x, self.pos.y)
end

return endScene



