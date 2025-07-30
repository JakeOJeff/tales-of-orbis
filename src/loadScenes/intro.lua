local intro = {
    imgs = {
        love.graphics.newImage("assets/vfx/loading/titles/background.png"),
        love.graphics.newImage("assets/vfx/loading/titles/tales-of-text.png"),
        love.graphics.newImage("assets/vfx/loading/titles/orb-light.png"),
        love.graphics.newImage("assets/vfx/loading/titles/orb-text.png"),
        love.graphics.newImage("assets/vfx/loading/titles/play.png"),
    },
    timer = 0,
    fadeTime = 0.5, -- seconds for fade in
    delayBetween = .5, -- seconds between each image's start time
    startTime = nil,
    play_x = 527,
    play_y = 340,
    play_width = 240,
    play_height = 90,
    normal_play = love.graphics.newImage("assets/vfx/loading/titles/play.png"),
    hover_play = love.graphics.newImage("assets/vfx/loading/titles/play-hover.png"),
}

function intro:load()
    self.startTime = love.timer.getTime()
end

function intro:update(dt)
    self.timer = love.timer.getTime() - self.startTime
    local mx, my = love.mouse.getPosition()
    if mx > self.play_x and mx < self.play_x + self.play_width and my > self.play_y and my < self.play_y + self.play_height then
        self.imgs[5] = self.hover_play
    else
        self.imgs[5] = self.normal_play
    end
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
