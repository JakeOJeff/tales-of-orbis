local Camera = {
    x = 0,
    y = 0,
    scale = scale + 1
}

if love.system.getOS() == "Android" then
    game.scale = scale + 1.3
end

function Camera:apply()
    love.graphics.push()

    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:clear()
    love.graphics.pop()
end

function Camera:setPosition(x, y)

    self.x = x - love.graphics.getWidth() / 2 / self.scale
    self.y = y

    local rH = self.x + love.graphics.getWidth() /2

    if self.x < 0 then
        self.x = 0
    elseif rH > MapWidth then 
        self.x = MapWidth - love.graphics.getWidth() / 2
    end


end

return Camera