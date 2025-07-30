local intro = {
    imgs = {
        love.graphics.newImage("assets/vfx/loading/titles/background.png"),
        love.graphics.newImage("assets/vfx/loading/titles/tales-of-text.png"),
        love.graphics.newImage("assets/vfx/loading/titles/orb-light.png"),
        love.graphics.newImage("assets/vfx/loading/titles/orb-text.png")
    },
    timer = 0,
    fadeTime = 2.5, -- seconds for fade in
    delayBetween = 3, -- seconds between each image's start time
    startTime = nil
}

function intro:load()
    self.startTime = love.timer.getTime()
end

function intro:update(dt)
    self.timer = love.timer.getTime() - self.startTime
end

function intro:draw()
    for i, img in ipairs(self.imgs) do
        local appearTime = (i - 1) * self.delayBetween
        local t = self.timer - appearTime

        if t >= 0 then
            local alpha = math.min(t / self.fadeTime, 1)
            love.graphics.setColor(1, 1, 1, alpha)
            love.graphics.draw(img, 0, 0)
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return intro
