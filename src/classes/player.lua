Player = {

}

function Player:load()
    self.x = 100
    self.y = 0
    self.width = 20
    self.height = 60
    self.xVel = 0
    self.yVel = 100
    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 3500

    self.maxSpeed = 200 -- 200/4000 = 0.05 seconds

    self.physics = {}
    self.physics.body = love.physics.newBody(World,self.x,self.y,"dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end
function Player:update(dt)
    self:syncPhysics()
end

function Player:move(dt)

    print(lH) -- useful for debugging joystick movement

    if love.keyboard.isDown("d", "right") or lH > 0.2 then -- small deadzone
        local incrementVal = self.xVel + self.acceleration * dt
        if incrementVal < self.maxSpeed then
            self.xVel = incrementVal
        else
            self.xVel = self.maxSpeed
        end
    end

end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end
function  Player:draw()
    love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
end