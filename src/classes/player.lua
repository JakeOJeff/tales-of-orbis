Player = {}

function Player:load()
    self.x = 100
    self.y = 100
    self.checkpointX = self.x
    self.checkpointY = self.y
    self.radius = 16
    --self.height = 28
    self.xVel = 0
    self.yVel = 100
    self.maxSpeed = 100 -- 200/4000 = 0.05 seconds
    self.acceleration = 2000
    self.friction = 2000

    self.gravity = 100
    self.grounded = false
    self.jumpAmount = -175
    self.currentGroundCollision = nil

    self.maxBoost = 550
    self.boost = self.maxBoost
    self.isBoosting = false

    self.health = {
        current = 0,
        max = 100
    }
    self.alive = true

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

    self.bobSpeed = 4
    self.bobRange = 10

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newCircleShape(self.radius)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end
function Player:update(dt)
    local airborne = not self.grounded
    local boosting = self.isBoosting

    if airborne or boosting then
        -- Particle properties
        self.particleMaxLife = airborne and 6 or 4
        self.particleSize = airborne and 6 or 4
        self.particleRadius = love.math.random() * 20

        -- Boosting overrides acceleration/friction
        if boosting then
            self.emissionRate = 1000
            self.acceleration = 4500
            self.friction = 1000
            self.maxSpeed = 250
        else
            -- Restore normal movement if not boosting
            self.acceleration = 2000
            self.friction = 2000
            self.maxSpeed = 100 -- 200/4000 = 0.05 seconds
        end
    else
        -- Neither airborne nor boosting: reset everything
        self:resetTrails()
        self.acceleration = 2000
        self.friction = 2000
        self.maxSpeed = 100 -- 200/4000 = 0.05 seconds
    end

    if GUI.jumpButton.holding then
        self:jump()
    end

    self.animations.idle:update(dt)
    self:updateTrail(dt)
    self:respawn()
    self:syncPhysics()
    self:applyGravity(dt)
    self:move(dt)
    self:decreaseGraceTime(dt)
end

function Player:takeDamange(amount)
    if self.health.current - amount > 0 then
        self.health.current = self.health.current - amount
    else
        self.health.current = 0
        self:die()
    end
    print("Health : "..self.health.current)
end

function Player:die()
    self.alive = false
    print("player died")
end

function Player:respawn()
    if not self.alive then
        self.physics.body:setPosition(self.checkpointX, self.checkpointY)
        self.health.current = self.health.max
        self.alive = true
    end
end
function Player:resetTrails()

    self.particleMaxLife = 1
    self.particleSize = 5
    -- self.bobRange = 10
    -- self.bobSpeed = 7
    self.particleRadius = love.math.random() * 15
    self.emissionRate = 500
    self.acceleration = 2000
    self.friction = 2000
    self.maxSpeed = 100 -- 200/4000 = 0.05 seconds
end
-- function Player
function Player:move(dt)
    if love.keyboard.isDown("d", "right") or jAxes[1] > 0.2 or GUI.rightButton.holding then -- small deadzone
        self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("a", "left") or (jAxes[1] or 0) < -0.2 or GUI.leftButton.holding then
        self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)

    else
        self:applyFriction(dt)
    end

    local isBoostKeyDown = love.keyboard.isDown("lshift", "lctrl") or GUI.boostButton.holding
    local isJoystickBoost = false

    if Joystick then
        isJoystickBoost = Joystick:isGamepadDown("leftstick")
    end

    if jAxes[1] ~= 0 then
        isMobile = false
    end
 
    if (isBoostKeyDown or isJoystickBoost) and self.boost > 0 and self.xVel ~= 0 then
        self.boost = math.max(0, self.boost - 5 * dt)
        self.isBoosting = true
        print(self.boost)
    else
        self.isBoosting = false
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
        self.particleMaxLife = 2
        self.particleSize = 10
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
            y = self.y + (self.bobRange * math.sin(love.timer.getTime() * self.bobSpeed)) + dy,
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
    local pX = self.x
    local pY = self.y + (self.bobRange * math.sin(love.timer.getTime() * self.bobSpeed))
    -- love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    self.animations.idle:draw(self.spritesheet, pX - 16, pY - 25)
    -- love.graphics.circle("line", self.x, self.y, self.radius)
end
