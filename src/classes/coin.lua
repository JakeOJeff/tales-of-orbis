Coin = {}
Coin.__index = Coin
ActiveCoins = {}

function Coin.new(x, y)
    local instance = setmetatable({}, Coin)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("assets/vfx/items/fire.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    table.insert(ActiveCoins, instance)
    return instance
end

function Coin:update(dt)

end

function Coin.updateAll(dt)
    for i, v in ipairs(ActiveCoins) do
        v:draw()
    end
end
function Coin:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

function Coin.drawAll()
    for i, v in ipairs(ActiveCoins) do
        v:draw()
    end
end
