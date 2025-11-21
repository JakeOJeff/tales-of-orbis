local loading = {
    imgs = {LG.newImage("assets/vfx/loading/light_load.png"),
            LG.newImage("assets/vfx/loading/night_load.png")},
    loaded = 0, -- In percentages
    time = 0, -- text loading 
    speed = 10,
    assets = 0,
    alpha = 1,
    text = "loading.", -- loading text
    particles = {},
    emissionRate = 5,
    timeSinceLastEmit = 0
}

function loading:load()
    
    if IsMobile then
        love.window.setFullscreen(true)
        scaleGame()
    end

    introTrack:play()
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

    -- self.emissionRate = 50 * dt

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

    if self.loaded > 150 then
        self.setScene("production")
    elseif self.loaded > 100 then
        self.text = "loaded."
    end
end

function loading:draw()
    LG.push()
    LG.setColor(1, 1, 1, self.alpha)
    LG.draw(self.imgs[1], 0, 0, 0, wW / self.imgs[1]:getWidth(), scale)
    LG.scale(scale, scale)
    LG.translate(cenW, cenH)

    LG.setColor(0.79, 0.5, 0.19, self.alpha)
    LG.setFont(heading)
    LG.print(self.text, baseW / 2 - heading:getWidth(self.text) / 2, baseH / 2 - heading:getHeight() / 2)
    LG.pop()

    LG.setScissor(0, 0, wW, (self.loaded / 100) * baseH * scale)
            LG.push()

    LG.setColor(1, 1, 1, self.alpha)
    LG.draw(self.imgs[2], 0, 0, 0, wW / self.imgs[2]:getWidth(), scale)

    LG.scale(scale, scale)
    LG.translate(cenW, cenH)

    LG.setColor(1, 1, 1, 0.5)
    LG.setFont(heading)
    LG.print(self.text, baseW / 2 - heading:getWidth(self.text) / 2, baseH / 2 - heading:getHeight() / 2)

    -- if love.system.getOS() ~= "Android" then
    LG.pop()
    LG.setScissor()

    LG.push()
        LG.scale(scale, scale)
    for _, p in ipairs(self.particles) do
        local alpha = p.life / p.maxLife
        LG.setColor(1, 1, 1, alpha)
        LG.circle("fill", p.x, p.y, 3)
    end
    LG.pop()

    -- end

end

function spawnParticle(particles)
    local y = loading.loaded / 100 * baseH

    for x = 0, wW, 4 do
        local speed = math.random(10, 30)
        local particle = {
            x = x,
            y = y,
            vx = 0,
            vy = -speed,
            life = .5,
            maxLife = .5
        }

        table.insert(particles, particle)
    end
end

return loading
