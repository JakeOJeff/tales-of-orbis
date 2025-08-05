local title = {
    imgs = {
        love.graphics.newImage("assets/vfx/loading/titles/background.png"),
        love.graphics.newImage("assets/vfx/loading/titles/tales-of-text.png"),
        love.graphics.newImage("assets/vfx/loading/titles/orb-light.png"),
        love.graphics.newImage("assets/vfx/loading/titles/orb-text.png"),
    },
    timer = 0,
    fadeTime = 1, -- seconds for fade in
    delayBetween = 3,
    startTime = nil,
    play_x = 527,
    play_y = 340,
    play_width = 240,
    play_height = 90,
    normal_play = love.graphics.newImage("assets/vfx/loading/titles/play.png"),
    hover_play = love.graphics.newImage("assets/vfx/loading/titles/play-hover.png"),
    currentPlayButton = nil,
}

function title:load()
    self.startTime = love.timer.getTime()
    self.currentPlayButton = self.normal_play
end

function title:update(dt)
    self.timer = love.timer.getTime() - self.startTime
    local mx, my = normalizeCoords(love.mouse.getPosition())
    self:handlePlayHover(mx, my, love.mouse.isDown(1))
end

function title:handlePlayHover(x, y, isPressed)
    local inPlay = distRect(x, y, self.play_x, self.play_y, self.play_width, self.play_height)
    self.currentPlayButton = inPlay and self.hover_play or self.normal_play
    if inPlay and isPressed then
        title.setScene("intro")
    end
end

function title:draw()
    for i, img in ipairs(self.imgs) do
        local appearTime = (i - 1) * self.delayBetween
        local t = self.timer - appearTime

        if t >= 0 then
            local alpha = math.min(t / self.fadeTime, 1)
            love.graphics.setColor(1, 1, 1, alpha)
            love.graphics.push()
            love.graphics.scale(scale, scale)
            love.graphics.translate(cenW, cenH)
            love.graphics.draw(img, 0, 0)
            love.graphics.pop()
        end
    end

    -- Draw play button last
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.push()
    love.graphics.scale(scale, scale)
    love.graphics.translate(cenW, cenH)
    love.graphics.draw(self.currentPlayButton, self.play_x, self.play_y)
    love.graphics.pop()
end

function title:keypressed(key)
    if key == "return" then
        title.setScene("intro")
    end
end

function title:gamepadpressed(joystick, button)
    isMobile = false
    if button == "a" then
        title.setScene("intro")
    end
end

function title:touchpressed(id, x, y)
    isMobile = true
    local normX, normY = normalizeCoords(x, y)
    self:handlePlayHover(normX, normY, true)
end

return title
