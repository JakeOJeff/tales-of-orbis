local loading = {
    imgs = {love.graphics.newImage("assets/vfx/loading/light_load.png"),
            love.graphics.newImage("assets/vfx/loading/night_load.png")},
    loaded = 0, -- In percentages
    time = 0, -- text loading 
    speed = 5,
    assets = 0,
    text = "loading." -- loading text
}

function loading:load()
    -- TO DO LATER : ASSET COUNTING 
    
    -- local files = love.filesystem.getDirectoryItems("assets/vfx/loading")
    -- print(#files)
    -- for _, file in ipairs(files) do
    --     if file:match("%.png") or file:match("%.jpeg") or file:match("%.jpg") or file:match("%.ttf") then
    --         self.assets = self.assets + 1
    --         print(self.assets)
    --     end
    -- end
end 

function loading:update(dt)

    self.loaded = self.loaded + (self.speed * dt)
    self.time = self.time + (1 * dt)

    if (self.text ~= "loading....")then
        if self.time > self.speed/self.loaded then
            self.text = self.text .. "."
            self.time = 0
        end
    else
        self.text = "loading."
    end

    if self.loaded > 125 then
        self.setScene("game")
    elseif self.loaded > 100 then
        self.text = "loaded."
    end
end

function loading:draw()
    love.graphics.draw(self.imgs[1], 0, 0)

    love.graphics.setScissor(0, 0, wW, self.loaded / 100 * wH)
    love.graphics.draw(self.imgs[2], 0, 0)
    love.graphics.setScissor()

    love.graphics.setFont(heading)
    love.graphics.print(self.text, wW/2 - heading:getWidth(self.text)/2, wH/2 - heading:getHeight()/2)
end

return loading
