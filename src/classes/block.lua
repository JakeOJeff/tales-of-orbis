Block = {}
Block.__index = Block
ActiveBlocks = {}

function Block.new(x, y)
    local instance = setmetatable({}, Block)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("assets/vfx/items/blackhole.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()


    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    table.insert(ActiveBlocks, instance)
    return instance
end

function Block:update(dt)

end

function Block.updateAll(dt)
    for i, v in ipairs(ActiveBlocks) do
        v:update(dt)
    end
end

function Block:draw()

    local offsetX = (3 * math.cos(love.timer.getTime() * 3))
    local offsetY = (3 * math.sin(love.timer.getTime() * 3))

    love.graphics.draw(self.img, self.x + offsetX, self.y + offsetY, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Block.drawAll()
    for i, v in ipairs(ActiveBlocks) do
        v:draw()
    end
end

