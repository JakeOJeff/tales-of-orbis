Mirror = {}
Mirror.__index = Mirror
ActiveMirrors = {}

function Mirror.new(x, y)
    local instance = setmetatable({}, Block)
    instance.x = x
    instance.y = y
    instance.img = LG.newImage("assets/vfx/items/block.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.r = 0


    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(5)
    table.insert(ActiveMirrors, instance)
    return instance
end

function Mirror:update(dt)
    self:syncPhysics()
end

function Mirror:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function Mirror.updateAll(dt)
    for i, v in ipairs(ActiveMirrors) do
        v:update(dt)
    end
end

function Mirror:draw()
    LG.draw(self.img, self.x, self.y, self.r, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Mirror.drawAll()
    for i, v in ipairs(ActiveMirrors) do
        v:draw()
    end
end

function Mirror.clear()
    for i, v in ipairs(ActiveMirrors) do
        v.physics.body:destroy()
    end
    ActiveMirrors = {}
end
