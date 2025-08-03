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

    table.insert(ActiveFire, instance)
    return instance
end

function Fire:update(dt)
    self:spin(dt)
end

function Fire:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2 + self.randomTimeOffset)
end
function Fire.updateAll(dt)
    for i, v in ipairs(ActiveFire) do
        v:update(dt)
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
