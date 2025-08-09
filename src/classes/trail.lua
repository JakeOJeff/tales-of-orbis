-- Trail.lua
local Trail = {}
Trail.__index = Trail

function Trail:new(imgBack, imgMain, maxParticles)
    return setmetatable({
        particles = {},
        spawnTimer = 0,
        emissionRate = 500, -- per second
        maxParticles = maxParticles or 800,

        particleSize = 24,
        particleLife = 0.4,
        particleSpeed = 2,

        imageBack = imgBack,
        imageMain = imgMain
    }, Trail)
end

function Trail:spawn(x, y, radius, grounded)
    -- radius: how far from player to spawn
    -- grounded: whether to offset spawning for ground trails
    local angle = love.math.random() * math.pi * 2
    local offsetX = grounded and math.cos(angle) * radius or 0
    local offsetY = grounded and math.sin(angle) * radius or 0

    local speed = love.math.random() * self.particleSpeed

    local particle = {
        x = x + offsetX,
        y = y + offsetY,
        size = self.particleSize,
        vx = math.cos(angle) * speed,
        vy = math.sin(angle) * speed,
        life = self.particleLife,
        maxLife = self.particleLife
    }

    table.insert(self.particles, particle)
end

function Trail:update(dt, playerX, playerY, radius, grounded, activeBlackholes)
    -- Spawn particles at emission rate
    self.spawnTimer = self.spawnTimer + dt
    local toSpawn = math.floor(self.spawnTimer * self.emissionRate)
    self.spawnTimer = self.spawnTimer - toSpawn / self.emissionRate

    for i = 1, toSpawn do
        if #self.particles < self.maxParticles then
            self:spawn(playerX, playerY, radius, grounded)
        end
    end

    -- Update existing particles
    for i = #self.particles, 1, -1 do
        local p = self.particles[i]

        -- Blackhole attraction
        if activeBlackholes then
            for _, blackhole in ipairs(activeBlackholes) do
                local dx = blackhole.x - p.x
                local dy = blackhole.y - p.y
                local dist = math.sqrt(dx * dx + dy * dy)

                if dist < 20 then
                    table.remove(self.particles, i)
                    goto continue
                end

                if dist < 100 then
                    local pull = (1 - dist / 100) * 200 -- stronger when closer
                    local angle = math.atan2(dy, dx)
                    p.vx = p.vx + math.cos(angle) * pull * dt
                    p.vy = p.vy + math.sin(angle) * pull * dt
                end
            end
        end

        -- Motion update
        p.x = p.x + p.vx
        p.y = p.y + p.vy

        -- Fade & shrink
        p.life = p.life - dt
        p.size = p.size - dt * 10

        if p.life <= 0 or p.size <= 0 then
            table.remove(self.particles, i)
        end

        ::continue::
    end
end

function Trail:draw()
    for _, p in ipairs(self.particles) do
        local alpha = p.life / p.maxLife
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.draw(self.imageBack, p.x - self.imageBack:getWidth() / 2,
            p.y - self.imageBack:getHeight() / 2,
            0, p.size / self.imageBack:getWidth(), p.size / self.imageBack:getHeight())

        love.graphics.draw(self.imageMain, p.x - self.imageMain:getWidth() / 2,
            p.y - self.imageMain:getHeight() / 2,
            0, p.size / self.imageMain:getWidth(), p.size / self.imageMain:getHeight())
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return Trail
