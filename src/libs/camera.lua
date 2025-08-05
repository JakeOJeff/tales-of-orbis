local Camera = {
    x = 0,
    y = 0,
    scale = scale + 1
}

if wW/wH then
    Camera.scale = scale + 1.3
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
    -- Center X and Y on the player
    self.x = x - love.graphics.getWidth() / 2 / self.scale
    self.y = y - love.graphics.getHeight() / 2 / self.scale

    -- Clamp X to map bounds
    local screenW = love.graphics.getWidth() / self.scale

    if self.x < 0 then
        self.x = 0
    elseif self.x + screenW > MapWidth then
        self.x = MapWidth - screenW
    end
end


return Camera