Block = {}
Block.__index = Block
ActiveBlocks = {}

function Block.new(x, y)
    local instance = setmetatable({}, Block)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("assets/vfx/items/block.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.r = 0


    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(15)
    table.insert(ActiveBlocks, instance)
    return instance
end

function Block:update(dt)
    self:syncPhysics()
end

function Block:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function Block.updateAll(dt)
    for i, v in ipairs(ActiveBlocks) do
        v:update(dt)
    end
end

function Block:draw()
    love.graphics.draw(self.img, self.x, self.y, self.r, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Block.drawAll()
    for i, v in ipairs(ActiveBlocks) do
        v:draw()
    end
end

function Block.clear()
    for i, v in ipairs(ActiveBlocks) do
        v.physics.body:destroy()
    end
    ActiveBlocks = {}
end
