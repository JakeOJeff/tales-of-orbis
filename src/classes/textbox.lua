Textbox = {}
Textbox.__index = Textbox
Textboxes = {}

local imageset = {
    le = LG.newImage("assets/vfx/textbox/ledge.png"),
    re = LG.newImage("assets/vfx/textbox/redge.png"),
    te = LG.newImage("assets/vfx/textbox/tedge.png"),
    be = LG.newImage("assets/vfx/textbox/bedge.png"),
    tlc = LG.newImage("assets/vfx/textbox/tlcorner.png"),
    trc = LG.newImage("assets/vfx/textbox/trcorner.png"),
    blc = LG.newImage("assets/vfx/textbox/blcorner.png"),
    brc = LG.newImage("assets/vfx/textbox/brcorner.png"),
    cen = LG.newImage("assets/vfx/textbox/center.png")
}

function Textbox:new(x, y, r, width, height)
    local instance = setmetatable({}, Textbox)

    instance.x = x
    instance.y = y
    instance.r = r 
    instance.width = width
    instance.height = height
    instance.canvas = LG.newCanvas(width, height)

    table.insert(Textboxes, instance)
    return instance

end

function Textbox:update(dt)
    
end

function Textbox.updateAll(dt)
    for i, v in ipairs(Textboxes) do
        v:update(dt)
    end
end
function Textbox:draw()
    local is = imageset

    LG.draw(is.tlc, self.x, self.y)
    LG.draw(is.te, self.x + is.tlc:getWidth(), self.y)
    LG.draw(is.trc, self.x +(self.width - is.trc:getWidth()), self.y)

    LG.draw(is.le, self.x, self.y + is.tlc:getHeight())
    LG.draw(is.cen, self.x + is.le:getWidth(), self.y + is.te:getHeight())
    LG.draw(is.re, self.x + (self.width - is.re:getWidth()), self.y + is.te:getHeight())

    LG.draw(is.blc, self.x, self.y + (self.height - is.blc:getHeight()))
    LG.draw(is.be, self.x + is.blc:getWidth(), self.y+ (self.height - is.be:getHeight()))
    LG.draw(is.brc, self.x +(self.width - is.brc:getWidth()), self.y+ (self.height - is.brc:getHeight()))

end
function Textbox.drawAll()
    for i, v in ipairs(Textboxes) do
        v:draw()
    end
end
return Textbox