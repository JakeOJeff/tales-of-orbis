local Camera = {
    x = 0,
    y = 0,
    targetX = 0,
    targetY = 0,
    scale = scale + 1.5,
    lerpSpeed = 6 -- Adjust this for smoother/slower movement
}

if wW / wH > 2 then
    Camera.scale = scale + 1.8
end

function Camera:apply()
    love.graphics.push()
    local dx = love.math.random(-4, 4)
    local dy = love.math.random(-4, 4)
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x * dx, -self.y)
end

function Camera:clear()
    love.graphics.pop()
end

function Camera:setPosition(x, y)
    local targetX = x - love.graphics.getWidth() / 2 / self.scale
    local targetY = y - love.graphics.getHeight() / 2 / self.scale

    local screenW = love.graphics.getWidth() / self.scale
    local screenH = love.graphics.getHeight() / self.scale

    if targetX < 0 then
        targetX = 0
    elseif targetX + screenW > MapWidth then
        targetX = MapWidth - screenW
    end

    if targetY < 0 then
        targetY = 0
    elseif targetY + screenH > MapHeight then
        targetY = MapHeight - screenH
    end

    self.targetX = targetX
    self.targetY = targetY
end

-- Smoothly update current position toward target
function Camera:update(dt)
    self.x = lerp(self.x, self.targetX, math.min(self.lerpSpeed * dt, 1))
    self.y = lerp(self.y, self.targetY, math.min(self.lerpSpeed * dt, 1))
end

return Camera
