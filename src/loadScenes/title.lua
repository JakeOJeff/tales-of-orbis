local title = {
    imgs = {
        love.graphics.newImage("assets/vfx/loading/titles/background.png"),
        love.graphics.newImage("assets/vfx/loading/titles/tales-of-text.png"),
        love.graphics.newImage("assets/vfx/loading/titles/orb-light.png"),
        love.graphics.newImage("assets/vfx/loading/titles/orb-text.png"),
        love.graphics.newImage("assets/vfx/loading/titles/play.png") -- Play button is last
    },
    timer = 0,
    fadeTime = 1,         -- seconds to fade each image
    delayBetween = 3,     -- delay between each image
    startTime = nil,
    play_x = 527,
    play_y = 340,
    play_width = 240,
    play_height = 90,
    normal_play = love.graphics.newImage("assets/vfx/loading/titles/play.png"),
    hover_play = love.graphics.newImage("assets/vfx/loading/titles/play-hover.png"),
}



function title:load()
    self.startTime = love.timer.getTime()
end

function title:update(dt)
    self.timer = love.timer.getTime() - self.startTime

    local mx, my = normalizeCoords(love.mouse.getPosition())
    local inPlay = distRect(mx, my, self.play_x, self.play_y, self.play_width, self.play_height)

    -- Swap play button image if hovered
    self.imgs[5] = inPlay and self.hover_play or self.normal_play

    -- Handle click
    if inPlay and love.mouse.isDown(1) then
        title.setScene("intro")
    end
end

function title:draw()
    love.graphics.push()
    love.graphics.scale(scale, scale)
    love.graphics.translate(cenW, cenH)

    for i, img in ipairs(self.imgs) do
        local appearTime = (i - 1) * self.delayBetween
        local t = self.timer - appearTime

        if t >= 0 then
            local alpha = math.min(t / self.fadeTime, 1)
            love.graphics.setColor(1, 1, 1, alpha)
            love.graphics.draw(img, 0, 0)
        end
    end

    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
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
    local tx, ty = normalizeCoords(x, y)
    local inPlay = distRect(tx, ty, self.play_x, self.play_y, self.play_width, self.play_height)
    self.imgs[5] = inPlay and self.hover_play or self.normal_play

    if inPlay then
        title.setScene("intro")
    end
end

return title
