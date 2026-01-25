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
    self.timeInterval = 5

    self.pos = {
        x = 0,
        y = 0
    }
    
end

function endScene:update(dt)
    self.time = self.time + dt

    if self.time > self.timeInterval then
        self.time = 0
    end
    self.pos.x = subheading:getWidth(self.text[self.index])

    self.pos.y = (wH / 2 + subheading:getHeight()/2 + 40) - 40 * self.time/self.timeInterval
end

function endScene:draw()
    lg.setFont(subheading)
    lg.setColor(1,1,1,self.time/self.timeInterval)
    lg.print(self.text[self.index], self.pos.x, self.pos.y)
end

return endScene