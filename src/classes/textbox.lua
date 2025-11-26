local LG = love.graphics

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
    cen = LG.newImage("assets/vfx/textbox/center.png"),
}



function Textbox:new(text, x, y, r, width, height)
    local instance = setmetatable({}, Textbox)

    instance.x = x
    instance.y = y
    instance.r = r
    instance.width = width * scale
    instance.height = height * scale
    instance.text = text or "text"

    instance.font = LG.newFont("assets/fonts/nihonium.ttf", instance.height/2)

    -- Stretch to text
    if instance.font:getWidth(instance.text) > instance.width - 16*scale then
        instance.width = instance.font:getWidth(instance.text) + 16*scale
    end

    instance.canvas = LG.newCanvas(instance.width, instance.height)

    instance.visible = false
    instance.time = 0
    instance.state = "hidden"    -- "appearing", "visible", "disappearing"
    instance.scale = 0.5         -- NEW scale animation (starts small)

    table.insert(Textboxes, instance)
    return instance
end

function Textbox:update(dt)
    if self.state == "appearing" then
        self.time = self.time + dt * 2 -- speed factor
        local t = math.min(self.time, 1)

        -- Bounce scale
        self.scale = easeOutBack(t)

        -- Rotation wobble
        self.r = math.sin(love.timer.getTime() * 12) * math.rad(4) * (1 - t)

        if t >= 1 then
            self.state = "visible"
            self.time = 0
        end

    elseif self.state == "visible" then
        -- idle micro-movement
        self.time = self.time + dt * 2
        local t = math.min(self.time, 3)

        self.r = math.sin(love.timer.getTime() * 2) * math.rad(1)

        if t >= 3 then
            self:hide()
        end
        

    elseif self.state == "disappearing" then
        self.time = self.time + dt * 2
        local t = math.min(self.time, 1)

        -- shrink + ease inward
        self.scale = easeInBack(1 - t)

        -- rotation settles
        self.r = lerp(self.r, 0, t)

        if t >= 1 then
            self.state = "hidden"
            self.visible = false
        end
    end
end

function Textbox.updateAll(dt)
    for _, v in ipairs(Textboxes) do
        v:update(dt)
    end
end

function Textbox:draw()
    if not self.visible then return end

    -- draw 9-slice into canvas first
    LG.setCanvas(self.canvas)
    LG.clear()

    local is = imageset
    local x, y = 0, 0
    local w, h = self.width, self.height

    local tlw, tlh = is.tlc:getWidth(), is.tlc:getHeight()
    local trw, trh = is.trc:getWidth(), is.trc:getHeight()
    local blw, blh = is.blc:getWidth(), is.blc:getHeight()
    local brw, brh = is.brc:getWidth(), is.brc:getHeight()

    local innerX = x + tlw
    local innerY = y + tlh
    local innerW = w - tlw - trw
    local innerH = h - tlh - blh

    LG.draw(is.tlc, x, y)
    LG.draw(is.te, innerX, y, 0, innerW / is.te:getWidth(), 1)
    LG.draw(is.trc, x + (w - trw), y)

    LG.draw(is.le, x, y + tlh, 0, 1, innerH / is.le:getHeight())
    LG.draw(is.cen, innerX, innerY, 0, innerW / is.cen:getWidth(), innerH / is.cen:getHeight())
    LG.draw(is.re, x + (w - trw), y + trh, 0, 1, innerH / is.re:getHeight())

    LG.draw(is.blc, x, y + (h - blh))
    LG.draw(is.be, innerX, y + (h - blh), 0, innerW / is.be:getWidth(), 1)
    LG.draw(is.brc, x + (w - brw), y + (h - brh))

    -- Text
    LG.setFont(self.font)
    LG.setColor(0, 0, 0, 0.5)
    LG.print(self.text, w/2 - self.font:getWidth(self.text)/2, h/2 - self.font:getHeight()/2 + 3*scale)

    LG.setColor(1, 1, 1, 1)
    LG.print(self.text, w/2 - self.font:getWidth(self.text)/2, h/2 - self.font:getHeight()/2)

    LG.setCanvas()

    -- apply bounce scale + rotation
    LG.push()
    local cx = self.x + w/2
    local cy = self.y + h/2

    LG.translate(cx, cy)
    LG.rotate(self.r)
    LG.scale(self.scale, self.scale)

    LG.draw(self.canvas, -w/2, -h/2)

    LG.pop()
end

function Textbox:project()
    self.visible = true
    self.state = "appearing"
    self.time = 0
end

function Textbox:hide()
    self.state = "disappearing"
    self.time = 0
end

function Textbox.drawAll()
    for _, v in ipairs(Textboxes) do
        v:draw()
    end
end

function Textbox:clear()
    Textboxes = {}
end

return Textbox
