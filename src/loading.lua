local loading = {
    imgs = {love.graphics.newImage("assets/vfx/loading/light_load.png"),
            love.graphics.newImage("assets/vfx/loading/night_load.png")},
    loaded = 0, -- In percentages
    time = 0, -- text loading 
    speed = 10,
    assets = 0,
    alpha = 1,
    text = "loading.", -- loading text
    particles = {},
    emissionRate = 50,
    timeSinceLastEmit = 0
}

function loading:load()
    self.loaded = 0 -- In percentages
    self.time = 0 -- text loading 
    self.speed = 10
    self.assets = 0
    self.alpha = 1
    self.text = "loading." -- loading text
    -- TO DO LATER : ASSET COUNTING 

    -- local files = love.filesystem.getDirectoryItems("assets/vfx/loading")
    -- print(#files)
    -- for _, file in ipairs(files) do
    --     if file:match("%.png") or file:match("%.jpeg") or file:match("%.jpg") or file:match("%.ttf") then
    --         self.assets = self.assets + 1
    --         print(self.assets)
    --     end
    -- end
end

function loading:update(dt)

    self.loaded = self.loaded + (self.speed * dt)
    self.time = self.time + (1 * dt)
    -- if love.system.getOS() ~= "Android" then

        self.timeSinceLastEmit = self.timeSinceLastEmit + dt
        local particlesToEmit = math.floor(self.timeSinceLastEmit * self.emissionRate)
        self.timeSinceLastEmit = self.timeSinceLastEmit - particlesToEmit / self.emissionRate

        for i = 1, particlesToEmit do
            spawnParticle(self.particles)
        end

        -- Update all particles
        for i = #self.particles, 1, -1 do
            local p = self.particles[i]
            p.x = p.x + p.vx * dt
            p.y = p.y + p.vy * dt
            p.life = p.life - dt
            if p.life <= 0 then
                table.remove(self.particles, i)
            end
        end

    -- end
    if (self.text ~= "loading....") then
        if self.time > self.speed / self.loaded then
            self.text = self.text .. "."
            self.time = 0
        end
    else
        self.text = "loading."
    end
    if self.loaded > 120 then
        self.alpha = self.alpha - (.5 * dt)

    end

    if self.loaded > 200 then
        self.setScene("production")
    elseif self.loaded > 100 then
        self.text = "loaded."
    end
end

function loading:draw()
    love.graphics.push()
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.draw(self.imgs[1], 0, 0, 0, wW / self.imgs[1]:getWidth(), scale)
    love.graphics.scale(scale, scale)
    love.graphics.translate(cenW, cenH)

    love.graphics.setColor(0.79, 0.5, 0.19, self.alpha)
    love.graphics.setFont(heading)
    love.graphics.print(self.text, baseW / 2 - heading:getWidth(self.text) / 2, baseH / 2 - heading:getHeight() / 2)
    love.graphics.pop()
    love.graphics.push()
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.setScissor(cenW, cenH, wW, (self.loaded / 100) * baseH * scale)

    love.graphics.draw(self.imgs[2], 0, 0, 0, wW / self.imgs[2]:getWidth(), scale)
    love.graphics.scale(scale, scale)
    love.graphics.translate(cenW, cenH)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.setFont(heading)
    love.graphics.print(self.text, baseW / 2 - heading:getWidth(self.text) / 2, baseH / 2 - heading:getHeight() / 2)

    love.graphics.setScissor()

    -- if love.system.getOS() ~= "Android" then

    for _, p in ipairs(self.particles) do
        local alpha = p.life / p.maxLife
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.circle("fill", p.x, p.y, 3)
    end

    -- end

    love.graphics.pop()
end

function spawnParticle(particles)
    local y = loading.loaded / 100 * baseH

    for x = 0, wW, 4 do
        local speed = math.random(30, 80)
        local particle = {
            x = x,
            y = y,
            vx = 0,
            vy = -speed,
            life = 1,
            maxLife = 1
        }

        table.insert(particles, particle)
    end
end

return loading
