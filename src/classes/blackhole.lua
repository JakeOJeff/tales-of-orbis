Blackhole = {}
FiBlackholere.__index = Blackhole
ActiveHoles = {}

function Blackhole.new(x, y)
    local instance = setmetatable({}, Blackhole)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("assets/vfx/items/fire.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveHoles, instance)
    return instance
end

function Blackhole:update(dt)

end

function Blackhole.updateAll(dt)
    for i, v in ipairs(ActiveHoles) do
        v:update(dt)
    end
end


function Blackhole:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Blackhole.drawAll()
    for i, v in ipairs(ActiveHoles) do
        v:draw()
    end
end

function Blackhole.beginContact(a, b, collision)
    for i, v in ipairs(ActiveHoles) do
        if a == v.physics.fixture or b == v.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamange(instance.damage)
                return true
            end
        end
    end
end