Fire = {}
Fire.__index = Fire
ActiveFire = {}

function Fire.new(x, y)
    local instance = setmetatable({}, Fire)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("assets/vfx/items/fire.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    instance.scaleX = 1
    instance.randomTimeOffset = math.random(0, 100)
    instance.toBeRemoved = false

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveFire, instance)
    return instance
end

function Fire:update(dt)
    self:spin(dt)
    self:checkRemoved()
end

function Fire:remove()
    for i, v in ipairs(ActiveFire) do
        if v == self then
            self.physics.body:destroy()
            table.remove(ActiveFire, i)
        end
    end
end

function Fire:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2 + self.randomTimeOffset)
end
function Fire.updateAll(dt)
    for i, v in ipairs(ActiveFire) do
        v:update(dt)
    end
end

function Fire:checkRemoved()
    if self.toBeRemoved then
        self:remove()
    end
end

function Fire:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Fire.drawAll()
    for i, v in ipairs(ActiveFire) do
        v:draw()
    end
end

function Fire.beginContact(a, b, collision)
    for i, v in ipairs(ActiveFire) do
        if a == v.physics.fixture or b == v.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                v.toBeRemoved = true
                return true
            end
        end
    end
end