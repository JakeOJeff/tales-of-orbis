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
    instance.canvas = LG.newCanvas(width * scale, height * scale)
    instance.font = LG.newFont()
    instance.visible = false

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
    local x, y = 0, 0
    local w, h = self.width * scale, self.height * scale


    local tlw, tlh = is.tlc:getWidth(), is.tlc:getHeight()
    local trw, trh = is.trc:getWidth(), is.trc:getHeight()
    local blw, blh = is.blc:getWidth(), is.blc:getHeight()
    local brw, brh = is.brc:getWidth(), is.brc:getHeight()

    local innerX = x + tlw
    local innerY = y + tlh
    local innerW = w - tlw - trw
    local innerH = h - tlh - blh

    LG.setCanvas(self.canvas)
    LG.clear()

    LG.draw(is.tlc, x, y)
    LG.draw(is.te, innerX, y, 0, innerW/is.te:getWidth(), 1)
    LG.draw(is.trc, x + (w - trw), y)

    LG.draw(is.le, x, y + tlh, 0, 1, innerH/is.le:getHeight())
    LG.draw(is.cen, innerX, innerY, 0, innerW/ is.cen:getWidth(), innerH/ is.cen:getHeight())
    LG.draw(is.re, x + (w - trw), y + trh, 0, 1, innerH/ is.re:getHeight())

    LG.draw(is.blc, x, y + (h - blh))
    LG.draw(is.be, innerX, y + (h - blh), 0, innerW / is.be:getWidth(), 1)
    LG.draw(is.brc, x + ( w - brw), y + (h - brh))

    LG.setCanvas()

    LG.push()
    local cx = self.x + (self.width * scale) / 2
    local cy = self.y + (self.height * scale) / 2
    LG.translate(cx, cy)
    LG.rotate(self.r)
    LG.draw(self.canvas, - (self.width * scale) / 2, - (self.height * scale) / 2)
    LG.pop()
end
function Textbox.drawAll()
    for i, v in ipairs(Textboxes) do
        v:draw()
    end
end

function Textbox:clear()
    Textboxes = {}
end
return Textbox