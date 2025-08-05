local Camera = {
    x = 0,
    y = 0,
    scale = scale + 1
}

if love.system.getOS() == "Android" then
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
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    -- Set centered position
    self.x = x - screenW / 2 / self.scale
    self.y = y - screenH / 2 / self.scale

    -- Right and bottom bounds
    local rightEdge = self.x + screenW / self.scale
    local bottomEdge = self.y + screenH / self.scale

    -- Clamp X
    if self.x < 0 then
        self.x = 0
    elseif rightEdge > MapWidth then 
        self.x = MapWidth - screenW / self.scale
    end

    -- Clamp Y
    if self.y < 0 then
        self.y = 0
    elseif bottomEdge > MapHeight then
        self.y = MapHeight - screenH / self.scale
    end
end


return Camera