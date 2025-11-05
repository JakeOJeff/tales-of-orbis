Relic = {}
Relic.__index = Relic
ActiveRelics = {}

function Relic.new(x, y)
    local instance = setmetatable({}, Relic)
    instance.x = x
    instance.y = y
    instance.img = LG.newImage("assets/vfx/items/relic.png")
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
    table.insert(ActiveRelics, instance)
    return instance
end

function Relic:update(dt)
    self:spin(dt)
    self:checkRemoved(dt)
end

function Relic:remove()
    for i, v in ipairs(ActiveRelics) do
        if v == self then
            self.physics.body:destroy()
            table.remove(ActiveRelics, i)
            Player.collectedRelics = Player.collectedRelics + 1
        end
    end
end

function Relic:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2 + self.randomTimeOffset)
end

function Relic.updateAll(dt)
    for i, v in ipairs(ActiveRelics) do
        v:update(dt)
    end
end

function Relic:checkRemoved(dt) 
    if self.toBeRemoved then 
        local img = GUI.relicsDisplay.src 
        local iw, ih = img:getWidth(), img:getHeight() 
        local dx = GUI.relicsDisplay.x + (GUI.relicsDisplay.w - iw * scale) / 2 + 128
        local dy = GUI.relicsDisplay.y + (GUI.relicsDisplay.h - ih * scale) / 2 + 20 + self.scaleX + 72 
        if self.x > dx  * scale and self.y > dy  * scale then 
            self.x = self.x - 30 * wW/100 * dt 
            self.y = self.y - 30 * wH/100 * dt 
            GUI.relicsDisplay.alpha = 1
        else 
            GUI.relicsDisplay.alpha = 0.6
            self:remove() 
        end
    end
end
function Relic:draw()
    LG.draw(self.img, self.x, self.y + self.scaleX * 4, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Relic.drawAll()
    for i, v in ipairs(ActiveRelics) do
        v:draw()
    end
end

function Relic.beginContact(a, b, collision)
    for i, v in ipairs(ActiveRelics) do
        if a == v.physics.fixture or b == v.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                v.toBeRemoved = true
                Player.pickedUpItem = true
                return true
            end
        end
    end
end

