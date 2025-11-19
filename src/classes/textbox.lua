Textbox = {}
Textbox.__index = Textbox
Textboxes = {}

local imageset = {
    le = love.graphics.newImage("assets/vfx/textbox/ledge.png"),
    re = love.graphics.newImage("assets/vfx/textbox/redge.png"),
    te = love.graphics.newImage("assets/vfx/textbox/tedge.png"),
    be = love.graphics.newImage("assets/vfx/textbox/bedge.png"),
    tlc = love.graphics.newImage("assets/vfx/textbox/tlcorner.png"),
    trc = love.graphics.newImage("assets/vfx/textbox/trcorner.png"),
    blc = love.graphics.newImage("assets/vfx/textbox/blcorner.png"),
    brc = love.graphicsa.newImage("assets/vfx/textbox/brcorner.png"),
    cen = love.graphics.newImage("assets/vfx/textbox/center.png")
}

function Textbox:new(x, y, r, width, height)
    local instance = setmetatable({}, Textbox)

    instance.x = x
    instance.y = y
    instance.r = r 
    instance.width = width
    instance.height = height
    instance.canvas = love.graphics.newCanvas(width, height)

end

function Textbox:update(dt)
    
end

function Textbox:draw()
    local is = imageset
    LG.draw(is.tlc, self.x, self.y)
    LG.draw(is.te, self.x + is.tlc:getWidth() + 10)
end

return Textbox