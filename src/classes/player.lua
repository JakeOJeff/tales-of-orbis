Player = {}

function Player:load()
    self.x = 100
    self.y = 0
    self.width = 20
    self.height = 60
    self.xVel = 0
    self.yVel = 100
    self.maxSpeed = 100 -- 200/4000 = 0.05 seconds
    self.acceleration = 2000
    self.friction = 2000

    self.gravity = 200
    self.grounded = false
    self.jumpAmount = -200
    self.currentGroundCollision = nil

    self.graceTime = 0
    self.graceDuration = 2

    self.spritesheet = love.graphics.newImage('assets/vfx/tilesets/player.png')
    self.grid = anim8.newGrid(32, 50, self.spritesheet:getWidth(), self.spritesheet:getHeight())

    self.animations = {
        idle = anim8.newAnimation(self.grid('1-3', 1), .1)
    }

    self.particles = {}
    self.particleRadius = love.math.random() * 25
    self.particleMaxLife = 3
    self.particleSize = 5
    self.emissionRate = 500 -- particles per second
    self.timeSinceLastEmit = 0

    self.bobSpeed = 7
    self.bobRange = 10

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end
function Player:update(dt)
    if not self.grounded then
        self.particleMaxLife = 10
        self.particleSize = 8
        -- self.bobRange = 3
        -- self.bobSpeed = 2
        self.particleRadius = love.math.random() * 20
    else
        self.particleMaxLife = 1
        self.particleSize = 5
        -- self.bobRange = 10
        -- self.bobSpeed = 7
        self.particleRadius = love.math.random() * 15
    end
    self.animations.idle:update(dt)
    self:updateTrail(dt)

    self:syncPhysics()
    self:applyGravity(dt)
    self:move(dt)
    self:decreaseGraceTime(dt)
end

-- function Player
function Player:move(dt)
    print(jAxes[1])
    if love.keyboard.isDown("d", "right") or jAxes[1] > 0.2 then -- small deadzone
        self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("a", "left") or (jAxes[1] or 0) < -0.2 then
        self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)

    else
        self:applyFriction(dt)
    end

end
function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end

end
function Player:applyFriction(dt)
    if self.xVel > 0 then
        self.xVel = math.min(self.xVel - self.friction * dt, 0)
    elseif self.xVel < 0 then
        self.xVel = math.max(self.xVel + self.friction * dt, 0)
    end
end

function Player:decreaseGraceTime(dt)
    if not self.grounded then
        self.graceTime = self.graceTime - dt
    end
end
function Player:keyboardInput(key)
    if key == "space" or key == "w" or key == "up" then
        self:jump()
    end
end

function Player:gamepadInput(button)
    if button == "a" then
        self:jump()
    end
end
function Player:jump()
    if self.grounded or self.graceTime > 0 then
        self.particleMaxLife = .5
        self.particleRadius = 5
        self.yVel = self.jumpAmount
        self.grounded = false
    end

end

function Player:beginContact(a, b, collision)
    if self.grounded then
        return
    end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.yVel = 0
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then 
            self.yVel = 0
        end
    end
end

function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end
function Player:updateTrail(dt)
    self.timeSinceLastEmit = self.timeSinceLastEmit + dt
    local particlesToEmit = math.floor(self.timeSinceLastEmit * self.emissionRate)
    self.timeSinceLastEmit = self.timeSinceLastEmit - particlesToEmit / self.emissionRate

    for i = 1, particlesToEmit do
        self:spawnTrailParticles()
    end

    for i = #self.particles, 1, -1 do
        local p = self.particles[i]
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        p.size = p.size * (1 - (p.life / p.maxLife)) - 0.1
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(self.particles, i)
        end
    end

end

function Player:spawnTrailParticles()
    for i = 1, 5 do -- emit 5 particles at once for a chunkier trail
        local angle = love.math.random() * 2 * math.pi
        local radius = self.particleRadius -- controls how far from center the particles spawn
        local speed = love.math.random(1, 2)

        local dx = math.cos(angle) * radius
        local dy = math.sin(angle) * radius

        local particle = {
            x = self.x + dx,
            y = self.y  + (self.bobRange * math.sin(love.timer.getTime() * self.bobSpeed)) + dy,
            size = self.particleSize,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed,
            life = 0.3 + love.math.random() * 0.2,
            maxLife = self.particleMaxLife -- less = higher density
        }

        table.insert(self.particles, particle)
    end
end

function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
    self.graceTime = self.graceDuration
end
function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end
function Player:draw()
    for _, p in ipairs(self.particles) do
        local alpha = p.life / p.maxLife
        -- love.graphics.setColor(0.79, 0.5, 0.19, alpha)
        love.graphics.setColor(0.56, 0.23, 0.11, alpha)

        love.graphics.circle("fill", p.x, p.y, p.size)
    end

    love.graphics.setColor(1, 1, 1, 1) -- reset color
    local pX = self.x - 32/2
    local pY = (self.y - 50/2) + (self.bobRange * math.sin(love.timer.getTime() * self.bobSpeed))
    -- love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    self.animations.idle:draw(self.spritesheet, pX, pY)
end
